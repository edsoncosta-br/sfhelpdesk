class RequestsController < ApplicationController
  before_action :set_request, only: %i[ edit update destroy ]

  def index
  end

  def new
    @request = Request.new
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

  def set_request
    @request = Request.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:title)
  end
end
