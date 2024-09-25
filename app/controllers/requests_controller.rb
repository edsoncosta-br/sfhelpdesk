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
                              "customers.name customers_name")
                      .joins(project: :company)
                      .joins(:user_created)
                      .left_joins(:user_responsible)
                      .left_joins(:mark)
                      .left_joins(:customer)
                      .where("users.company_id = ?", current_user.company.id)
                      .order(Arel.sql('priority desc, created_date desc, requests.id desc'))

    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end

    requests = requests.where('projects.id = ?', "#{params[:q_sys]}")

    if params[:q_status].blank?
      params[:q_status] = Constants::STEP_ABERTA[1]
    end    

    requests = requests.where('status = ?', "#{params[:q_status]}")

    if !params[:q_content].blank?
      requests = requests.where('unaccent(title) ilike unaccent(?)', "%#{params[:q_content]}%")
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
  end  

  def new
    @request = Request.new
    @request.status = Constants::STEP_ABERTA[1]
    @request.step = Constants::STATUS_AGUARDANDO[1]
    @request.created_date = DateTime.now()
    @request.project_id = params[:q_sys]
  end

  def create
    @request = Request.new(request_params)
    @request.user_created_id = current_user.id
    
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @request.save
          update_tag_ids(false)
          format.html { redirect_to requests_path(q_sys: params[:q_sys],
                                                  q_status: params[:q_status],
                                                  q_content: params[:q_content]), notice: "Requisição cadastrada com sucesso." }
        else
          format.html { render :new, status: :unprocessable_entity }
          @request.tag_ids = params[:tag_ids];
        end
      end
    end
  end

  def edit
    @request.tag_ids = RequestTag.where("request_id = ?", @request.id).pluck("tag_id")
  end

  def update
    ActiveRecord::Base.transaction do
      if @request.update(request_params)
        update_tag_ids(true)
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_content: params[:q_content]), notice: "Requisição atualizada com sucesso."
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
                                  q_content: params[:q_content]), notice: "Tópico excluído com sucesso."
      else
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_content: params[:q_content])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to requests_path(q_sys: params[:q_sys],
                                q_status: params[:q_status],
                                q_content: params[:q_content])
    end
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

  def request_params
    params.require(:request).permit(:title, :created_date, :due_date, :status,
                                    :step, :priority, :requester_name,
                                    :customer_id, :project_id, :user_created_id,
                                    :user_responsible_id, :mark_id, :content, 
                                    tag_ids: [])
  end
  
end