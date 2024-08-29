class RequestsController < ApplicationController
  before_action :set_request, only: %i[ edit update destroy ]
  before_action :set_upcase, only: %i[ create update ]    

  def index
    requests = Request.select(:id, :title, :status, :step, :priority, :customer_id,
                              :user_created_id, :user_responsible_id, :mark_id, :topic_id, :sub_topic_id,
                              "topics.description topic_description",
                              "sub_topics.description subtopic_description")
                      .joins(project: :company)
                      .joins(:topic)
                      .left_joins(:sub_topic)
                      .where("company_id = ?", current_user.company.id)
                      .order(Arel.sql('status'))

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
      if @request.save
        format.html { redirect_to requests_path(q_sys: params[:q_sys],
                                                q_content: params[:q_content]), notice: "Requisição cadastrada com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @request.update(request_params)
      redirect_to requests_path(q_sys: params[:q_sys],
                                q_content: params[:q_content]), notice: "Requisição atualizada com sucesso."
    else
      render :edit
    end      
  end

  def destroy
    begin
      if @request.destroy
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_content: params[:q_content]), notice: "Tópico excluído com sucesso."
      else
        redirect_to requests_path(q_sys: params[:q_sys],
                                  q_content: params[:q_content])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to requests_path(q_sys: params[:q_sys],
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

  def request_params
    params.require(:request).permit(:title, :created_date, :status,
                                    :step, :priority, :requester_name,
                                    :customer_id, :project_id, :user_created_id,
                                    :user_responsible_id, :mark_id, :topic_id,
                                    :sub_topic_id)
  end
  
end