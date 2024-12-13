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
        send_request_comment_created( @request_comment.request.project_id, 
                                      @request_comment.user_id, 
                                      @request_comment.request.id,
                                      @request_comment.request.title )

        format.html { redirect_to request_path(params[:q_id], q_sys: params[:q_sys],
                                                              q_status: params[:q_status],
                                                              q_code: params[:q_code],
                                                              q_content: params[:q_content],
                                                              q_tag: params[:q_tag],
                                                              q_customer: params[:q_customer],
                                                              q_responsible: params[:q_responsible],
                                                              q_mark: params[:q_mark],
                                                              q_order: params[:q_order]), 
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
                                                        q_code: params[:q_code],
                                                        q_content: params[:q_content],
                                                        q_tag: params[:q_tag],
                                                        q_customer: params[:q_customer],
                                                        q_responsible: params[:q_responsible],
                                                        q_mark: params[:q_mark],
                                                        q_order: params[:q_order]), 
                                                        notice: "Comentário atualizado com sucesso."      
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
                                  q_code: params[:q_code],
                                  q_content: params[:q_content],
                                  q_tag: params[:q_tag],
                                  q_customer: params[:q_customer],
                                  q_responsible: params[:q_responsible],
                                  q_mark: params[:q_mark],
                                  q_order: params[:q_order]), 
                                  notice: "Comentário excluído com sucesso."
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

  def send_request_comment_created(project_id, user_id, request_id, request_title)
    user_created = User.find(user_id)
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
                    request_comment_created.deliver_later
    end
  end  

  def set_request_comment
    @request_comment = RequestComment.find(params[:id])
  end

  def request_comment_params
    params.require(:request_comment).permit(:created_date, :user_id, :request_id, :content)
  end

end
