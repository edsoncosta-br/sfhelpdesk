class RequestCommentsController < ApplicationController
  def new
    @request_comment = RequestComment.new
  end

  def create
    @request_comment = RequestComment.new(request_comment_params)
    @request_comment.user_id = current_user.id
    @request_comment.created_date = DateTime.now()
    @request_comment.request_id = params[:q_id]
    
    respond_to do |format|
      if @request_comment.save
        format.html { redirect_to request_path(params[:q_id], q_sys: params[:q_sys],
                                                              q_status: params[:q_status],
                                                              q_content: params[:q_content]), 
                                                              notice: "Requisição atualizada com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_request_comment
    @request_comment = RequestComment.find(params[:id])
  end

  def request_comment_params
    params.require(:request_comment).permit(:created_date, :user_id, :request_id, :content)
  end

end
