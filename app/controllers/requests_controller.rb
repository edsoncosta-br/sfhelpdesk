class RequestsController < ApplicationController
  before_action :set_request, only: %i[ edit update destroy ]
  before_action :set_upcase, only: %i[ create update ]    

  def index
  end

  def new
    @request = Request.new
    @request.status = Constants::STEP_ABERTA[1]
    @request.step = Constants::STATUS_AGUARDANDO[1]

    @request.project_id = Allocation.joins(project: :company)
                                    .where("company_id = ? and allocations.user_id = ?", 
                                            current_user.company.id, current_user.id)
                                    .pick('projects.id')
  end

  def create
    @request = request.new(request_params)
    @request.company_id = current_user.company.id
    
    respond_to do |format|
      if @request.save
        format.html { redirect_to requests_path(q_desc: params[:q_desc]), notice: "Requisição cadastrada com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
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