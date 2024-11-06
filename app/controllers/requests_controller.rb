class RequestsController < ApplicationController
  before_action :set_request, only: %i[ edit update destroy ]
  before_action :set_upcase, only: %i[ create update ]
  before_action :purge_unattached, only: %i[ index ]

  def index
    requests = Request.select(:id, :title, :status, :step, :priority, 
                              :customer_id, :code, :requester_name,
                              :user_created_id, :user_responsible_id, 
                              :mark_id, :created_date, 
                              "coalesce(marks.due_date, requests.due_date) dues_date",
                              "users.nick_name user_created_name",
                              "user_responsibles_requests.nick_name user_responsible_name",
                              "marks.description mark_description",
                              "marks.closed",
                              "(select count(request_comments.id) from request_comments where request_comments.request_id = requests.id) count_comments",
                              "customers.name customers_name")
                      .joins(project: :company)
                      .joins(:user_created)
                      .left_joins(:user_responsible)
                      .left_joins(:mark)
                      .left_joins(:customer)
                      .joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = requests.id AND record_type = 'Request'")
                      .where("users.company_id = ?", current_user.company.id)

    # default params
    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end

    if params[:q_status].blank?
      params[:q_status] = Constants::STATUS_ABERTA[1]
    end
   
    if params[:q_order].blank?
      params[:q_order] = 'newest'
    end

    # filters
    requests = requests.where('projects.id = ?', "#{params[:q_sys]}")
    requests = requests.where('status = ?', "#{params[:q_status]}")

    if !params[:q_content].blank?
      requests = requests.where('(unaccent(title) ilike unaccent(?) or unaccent(action_text_rich_texts.body) ilike unaccent(?))', 
                                "%#{params[:q_content]}%", 
                                "%#{params[:q_content]}%")
    end
   
    if params[:q_status].to_s == Constants::STATUS_ABERTA[1].to_s
      if params[:q_order] == 'newest'
        requests = requests.order(Arel.sql('priority desc, created_date desc, requests.id desc'))
      else
        requests = requests.order(Arel.sql('priority desc, created_date, requests.id desc'))
      end
    else
      if params[:q_order] == 'newest'
        requests = requests.order(Arel.sql('created_date desc, requests.id desc'))
      else  
        requests = requests.order(Arel.sql('created_date, requests.id desc'))
      end
    end

    @requests = requests.all.page(params[:page]).per(Constants::PAGINAS)
    @requests_size = requests.size       
  end

  def show
    @requests = Request.select(:id, :title, :status, :step, :priority, 
                              :customer_id, :code, :requester_name,
                              :user_created_id, :user_responsible_id, 
                              :mark_id, :created_date,
                              "coalesce(marks.due_date, requests.due_date) dues_date",
                              "projects.description projects_description",
                              "users.nick_name user_created_name",
                              "user_responsibles_requests.nick_name user_responsible_name",
                              "marks.description mark_description",
                              "customers.name customers_name")
                      .joins(project: :company)
                      .joins(:user_created)
                      .left_joins(:user_responsible)
                      .left_joins(:mark)
                      .left_joins(:customer)
                      .where("requests.id = ?", params[:id])

    @request_tag_ids = RequestTag.where("request_id = ?", params[:id]).pluck("tag_id")                      
    @request_files = Request.where("requests.id = ?", params[:id]).with_attached_files

    @request_comments = RequestComment.joins(:user)
                                      .where("request_id = ?", params[:id])
                                      .order('request_comments.id')
  end  

  def new
    @request = Request.new
    @request.project_id = params[:q_sys]
    @request.status = Constants::STATUS_ABERTA[1]
    @request.step = Constants::STEP_AGUARDANDO[1]        
  end

  def create
    @request = Request.new(request_params)
    @request.user_created_id = current_user.id
    @request.created_date = DateTime.now()    
    @request.status = Constants::STATUS_ABERTA[1]
    @request.step = Constants::STEP_AGUARDANDO[1]    
    
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @request.save
          update_tag_ids(false)

          send_request_created( @request.project_id, 
                                @request.user_created_id, 
                                @request.id,
                                @request.title )

          format.html { redirect_to requests_path(q_sys: params[:q_sys],
                                                  q_status: params[:q_status],
                                                  q_content: params[:q_content], 
                                                  q_order: params[:q_order]), 
                                                  notice: "Requisição cadastrada com sucesso." }
        else
          format.html { render :new, status: :unprocessable_entity }
          @request.tag_ids = params[:tag_ids];
        end
      end
    end
  end

  def edit
    @request.tag_ids = RequestTag.where("request_id = ?", @request.id).pluck("tag_id")
    @request_files = Request.where("requests.id = ?", params[:id]).with_attached_files
  end

  def update
    ActiveRecord::Base.transaction do
      if @request.update(request_params)
        update_tag_ids(true)
        
        send_request_created( @request.project_id, 
                              @request.user_created_id, 
                              @request.id,
                              @request.title )

        redirect_to request_path(@request,q_sys: params[:q_sys],
                                          q_status: params[:q_status],
                                          q_content: params[:q_content],
                                          q_order: params[:q_order]), 
                                          notice: "Requisição atualizada com sucesso."
      else
        @request.tag_ids = params[:tag_ids];
        render :edit
      end
    end
  end

  def destroy
    begin
      if @request.destroy
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_content: params[:q_content],
                                  q_order: params[:q_order]), 
                                  notice: "Requisição excluída com sucesso."
      else
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_content: params[:q_content],
                                  q_order: params[:q_order])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to requests_path(q_sys: params[:q_sys],
                                q_status: params[:q_status],
                                q_content: params[:q_content],
                                q_order: params[:q_order])
    end
  end

  def delete_attachment
    attachment = Request.find(params[:id_request])
    attachment.files.find_by_id(params[:id_attachment]).purge    

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content],
                              q_order: params[:q_order]), 
                              notice: "Anexo excluído com sucesso."
  end

  def status_finished
    request = Request.find(params[:id_request])
    request.update(status: Constants::STATUS_FINALIZADA[1])

    send_request_finished(request.project_id, 
                          request.user_created_id, 
                          request.id,
                          request.title )

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content], 
                              q_order: params[:q_order]), 
                              notice: "Status Finalizado com sucesso."
  end

  def status_archived
    request = Request.find(params[:id_request])
    request.update(status: Constants::STATUS_ARQUIVADA[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content],
                              q_order: params[:q_order]), 
                              notice: "Status Arquivado com sucesso."
  end

  def status_reopen
    request = Request.find(params[:id_request])
    request.update(status: Constants::STATUS_ABERTA[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content],
                              q_order: params[:q_order]), 
                              notice: "Status Reaberto com sucesso."
  end

  def step_wait
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_AGUARDANDO[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content], 
                              q_order: params[:q_order]), 
                              notice: "Execução parada."
  end

  def step_execute
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_EXECUTANDO[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content], 
                              q_order: params[:q_order]), 
                              notice: "Execução iniciada."
  end
  
  def step_finish
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_CONCLUIDA[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_content: params[:q_content],
                              q_order: params[:q_order]), 
                              notice: "Execução alterada com sucesso."
  end  

  private

  def set_upcase
    Methods.field_upcase(params[:request])
  end    

  def set_request
    @request = Request.find(params[:id])
  end

  def update_tag_ids(updated)
    if updated
      request_tag = RequestTag.where("request_id = ?", @request.id)
      request_tag.delete_all
    end

    if params[:tag_ids]
      params[:tag_ids].each do |tag_id|
        RequestTag.create!(request_id: @request.id, tag_id: tag_id)
      end
    end    
  end

  def purge_unattached
    # delete attached files without references
    ActiveStorage::Blob.unattached.find_each(&:purge_later)
  end

  def send_request_created(project_id, user_created_id, request_id, request_title)
    user_created = User.find(user_created_id)
    users_list = Allocation.select("users.email, users.nick_name, projects.description as project_description")
                            .joins(:user)
                            .joins(:project)
                            .where("allocations.project_id = ?", project_id)

    users_list.each do |user_list|
      RequestMailer.with(email: user_list.email, 
                         name:  user_list.nick_name,
                         name_created: user_created.nick_name,
                         project_description: user_list.project_description,
                         request_title: request_title,
                         request_id: request_id).
                    request_created.deliver_later
    end
  end

  def send_request_finished(project_id, user_finished_id, request_id, request_title)
    user_finished = User.find(user_finished_id)
    users_list = Allocation.select("users.email, users.nick_name, projects.description as project_description")
                            .joins(:user)
                            .joins(:project)
                            .where("allocations.project_id = ?", project_id)

    users_list.each do |user_list|
      RequestMailer.with(email: user_list.email, 
                         name:  user_list.nick_name,
                         name_finished: user_finished.nick_name,
                         project_description: user_list.project_description,
                         request_title: request_title,
                         request_id: request_id).
                    request_finished.deliver_later
    end
  end  

  def request_params
    params.require(:request).permit(:title, :created_date, :due_date, :status,
                                    :step, :priority, :requester_name,
                                    :customer_id, :project_id, :user_created_id,
                                    :user_responsible_id, :mark_id, :content, 
                                    tag_ids: [], new_files:[])
  end
  
end