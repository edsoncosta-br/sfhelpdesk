class RequestsController < ApplicationController
  before_action :set_request, only: %i[ edit update destroy ]
  before_action :purge_unattached, only: %i[ index ]

  def index
    requests = Request.select(:id, :title, :status, :step, :priority, 
                              :customer_id, :code, :requester_name,
                              :user_created_id, :user_responsible_id, 
                              :mark_id, :created_date, :updated_at, :user_updated_id,
                              :finished_date, :archived_date,
                              :user_finished_id, :user_archived_id,
                              "coalesce(marks.due_date, requests.due_date) dues_date",
                              "users.nick_name user_created_name",
                              "user_responsibles_requests.nick_name user_responsible_name",
                              "user_updateds_requests.nick_name user_updated_name",
                              "user_finisheds_requests.nick_name user_finished_name",
                              "user_archiveds_requests.nick_name user_archived_name",
                              "marks.description mark_description",
                              "marks.closed",
                              "(select count(request_comments.id) from request_comments 
                                where request_comments.request_id = requests.id) count_comments",
                              "customers.name customers_name")
                      .joins(project: :company)
                      .joins(:user_created)
                      .left_joins(:user_updated)
                      .left_joins(:user_responsible)
                      .left_joins(:user_finished)
                      .left_joins(:user_archived)
                      .left_joins(:mark)
                      .left_joins(:customer)
                      .joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = requests.id and
                                                                  record_type = 'Request'")
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

    if !params[:q_code].blank?
      requests = requests.where('requests.id = ?', "#{params[:q_code]}")
    end

    if !params[:q_content].blank?
      requests = requests.where('(unaccent(title) ilike unaccent(?) or 
                                  unaccent(action_text_rich_texts.body) ilike unaccent(?))', 
                                "%#{params[:q_content]}%", 
                                "%#{params[:q_content]}%")
    end
   
    if !params[:q_tag].blank?
      requests = requests.where('exists (select 1 from request_tags where request_tags.request_id = requests.id and 
                                                                          request_tags.tag_id = ?)', "#{params[:q_tag]}")
    end    

    if !params[:q_customer].blank?
      requests = requests.where('customers.id = ?', "#{params[:q_customer]}")
    end

    if !params[:q_mark].blank?
      requests = requests.where('marks.id = ?', "#{params[:q_mark]}")
    end    

    if !params[:q_responsible].blank?
      requests = requests.where('user_responsibles_requests.id = ?', "#{params[:q_responsible]}")
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
                              :user_created_id, :user_responsible_id, :user_updated_id,
                              :mark_id, :created_date, :created_at, :updated_at,
                              :finished_date, :archived_date,
                              :user_finished_id, :user_archived_id,                              
                              "coalesce(marks.due_date, requests.due_date) dues_date",
                              "projects.description projects_description",
                              "users.nick_name user_created_name",
                              "user_responsibles_requests.nick_name user_responsible_name",
                              "user_updateds_requests.nick_name user_updated_name",
                              "user_finisheds_requests.nick_name user_finished_name",
                              "user_archiveds_requests.nick_name user_archived_name",
                              "marks.description mark_description",
                              "customers.name customers_name")
                      .joins(project: :company)
                      .joins(:user_created)
                      .left_joins(:user_updated)
                      .left_joins(:user_responsible)
                      .left_joins(:user_finished)
                      .left_joins(:user_archived)
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
                                                  q_code: params[:q_code],
                                                  q_content: params[:q_content],
                                                  q_tag: params[:q_tag],
                                                  q_customer: params[:q_customer],
                                                  q_responsible: params[:q_responsible],
                                                  q_mark: params[:q_mark],
                                                  q_order: params[:q_order]), 
                                                  notice: "Requisição cadastrada com sucesso." }
        else
          format.html { render :new, status: :unprocessable_entity }
          # @request.tag_ids = params[:tag_ids];
          @request.tag_ids = params[:tag_ids_selected].split;
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
      @request.user_updated_id = current_user.id

      if @request.update(request_params)
        update_tag_ids(true)
        
        send_request_created( @request.project_id, 
                              @request.user_created_id, 
                              @request.id,
                              @request.title )

        redirect_to request_path(@request,q_sys: params[:q_sys],
                                          q_status: params[:q_status],
                                          q_code: params[:q_code],
                                          q_content: params[:q_content],
                                          q_tag: params[:q_tag],
                                          q_customer: params[:q_customer],
                                          q_responsible: params[:q_responsible],
                                          q_mark: params[:q_mark],
                                          q_order: params[:q_order]), 
                                          notice: "Requisição atualizada com sucesso."
      else
        # @request.tag_ids = params[:tag_ids];
        @request.tag_ids = params[:tag_ids_selected].split;
        render :edit
      end
    end
  end

  def destroy
    begin
      if @request.destroy
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_code: params[:q_code],
                                  q_content: params[:q_content],
                                  q_tag: params[:q_tag],
                                  q_customer: params[:q_customer],
                                  q_responsible: params[:q_responsible],
                                  q_mark: params[:q_mark],
                                  q_order: params[:q_order]), 
                                  notice: "Requisição excluída com sucesso."
      else
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_code: params[:q_code],
                                  q_content: params[:q_content],
                                  q_tag: params[:q_tag],
                                  q_customer: params[:q_customer],
                                  q_responsible: params[:q_responsible],
                                  q_mark: params[:q_mark],
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
                                q_code: params[:q_code],
                                q_content: params[:q_content],
                                q_tag: params[:q_tag],
                                q_customer: params[:q_customer],
                                q_responsible: params[:q_responsible],
                                q_mark: params[:q_mark],
                                q_order: params[:q_order])
    end
  end

  def delete_attachment
    attachment = Request.find(params[:id_request])
    attachment.files.find_by_id(params[:id_attachment]).purge    

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Anexo excluído com sucesso."
  end

  def status_finished
    request = Request.find(params[:id_request])
    request.update( status: Constants::STATUS_FINALIZADA[1], 
                    step: Constants::STEP_CONCLUIDA[1],
                    finished_date: DateTime.now(),
                    archived_date: nil,
                    user_finished_id: current_user.id,
                    user_archived_id: nil)

    send_request_finished(request.project_id, 
                          request.user_created_id, 
                          request.id,
                          request.title )

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Status Finalizado com sucesso."
  end

  def status_archived
    request = Request.find(params[:id_request])
    request.update( status: Constants::STATUS_ARQUIVADA[1], 
                    step: Constants::STEP_AGUARDANDO[1],
                    finished_date: nil,
                    archived_date: DateTime.now(),
                    user_finished_id: nil,
                    user_archived_id: current_user.id)

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Status Arquivado com sucesso."
  end

  def status_reopen
    request = Request.find(params[:id_request])
    request.update( status: Constants::STATUS_ABERTA[1],
                    finished_date: nil,
                    archived_date: nil,
                    user_finished_id: nil,
                    user_archived_id: nil)

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Status Reaberto com sucesso."
  end

  def step_wait
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_AGUARDANDO[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Execução em espera."
  end

  def step_execute
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_EXECUTANDO[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Execução iniciada"
  end
  
  def step_finish
    request = Request.find(params[:id_request])
    request.update(step: Constants::STEP_CONCLUIDA[1])

    redirect_to request_path( params[:id_request] ,
                              q_sys: params[:q_sys],
                              q_status: params[:q_status],
                              q_code: params[:q_code],
                              q_content: params[:q_content],
                              q_tag: params[:q_tag],
                              q_customer: params[:q_customer],
                              q_responsible: params[:q_responsible],
                              q_mark: params[:q_mark],
                              q_order: params[:q_order]), 
                              notice: "Execução concluída."
  end  

  private

  def set_request
    @request = Request.find(params[:id])
  end

  def update_tag_ids(updated)
    if updated
      request_tag = RequestTag.where("request_id = ?", @request.id)
      request_tag.delete_all
    end

    if params[:tag_ids_selected]
      params[:tag_ids_selected].split.each do |tag_id|
        RequestTag.create!(request_id: @request.id, tag_id: tag_id)
      end
    end    
  end

  def purge_unattached
    Methods.purge_unattached
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
                                    :finished_date, :archived_date,
                                    :user_finished_id, :user_archived_id,
                                    tag_ids: [], new_files:[])
  end
  
end