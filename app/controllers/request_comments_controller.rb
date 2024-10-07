class RequestCommentsController < ApplicationController
  before_action :set_request_comment, only: %i[ edit update destroy ]

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
                                                              notice: "Comentário criado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @request_comment.update(request_comment_params)
      redirect_to request_path(@request_comment.request,q_sys: params[:q_sys],
                                                        q_status: params[:q_status],
                                                        q_content: params[:q_content]), notice: "Comentário atualizado com sucesso."      
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @request_comment.destroy
        redirect_to request_path(@request_comment.request.id, 
                                  q_sys: params[:q_sys],
                                  q_status: params[:q_status],
                                  q_content: params[:q_content]), notice: "Comentário excluído com sucesso."
      else
        redirect_to request_comments_path(q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to request_comments_path(q_desc: params[:q_desc])
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
