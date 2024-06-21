class SubTopicsController < ApplicationController
  before_action :set_sub_topic, only: %i[ edit update destroy ]

  def new
    @sub_topic = SubTopic.new
    @sub_topic.topic_id = params[:topic_id]
    show_system_topic(params[:topic_id]);
  end    

  def create
    @sub_topic = SubTopic.new(sub_topic_params)

    respond_to do |format|
      if @sub_topic.save
        format.html { redirect_to topics_path(q_sys: params[:q_sys],
                                              q_desc: params[:q_desc]), notice: "SubTópico cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    show_system_topic(@sub_topic.topic_id)
  end

  def update
    if @sub_topic.update(sub_topic_params)
      redirect_to topics_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc]), notice: "SubTópico atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @sub_topic.destroy
        redirect_to topics_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc]), notice: "SubTópico excluído com sucesso."
      else
        redirect_to topics_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to topics_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc])
    end
  end    

  private

  def set_sub_topic
    @sub_topic = SubTopic.find(params[:id])
  end

  def sub_topic_params
    params.require(:sub_topic).permit(:description, :topic_id, :description_system, :description_topic)
  end

  def show_system_topic(id) 
    description_system_topic = Topic.joins(system: :company)
                                      .where("company_id = ? and topics.id = ?", current_user.company.id, id)
                                      .pick('systems.description', 'topics.description')

    @sub_topic.description_system = description_system_topic[0]
    @sub_topic.description_topic = description_system_topic[1]    
  end

end
