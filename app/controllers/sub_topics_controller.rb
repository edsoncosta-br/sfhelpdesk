class SubTopicsController < ApplicationController
  before_action :set_sub_topic, only: %i[ edit update destroy ]
  before_action :set_upcase, only: %i[ create update ]    

  def new
    @sub_topic = SubTopic.new
    @sub_topic.topic_id = params[:topic_id]
    show_project_topic(params[:topic_id]);
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
    show_project_topic(@sub_topic.topic_id)
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

  def filter
    if !params[:request][:topic_id].empty?
      @sub_topics = SubTopic.select(:id, :description).order('unaccent(description)')
                            .where('topic_id = ?', params[:request][:topic_id]);
    else
      @sub_topics = ''
    end
  end    

  private

  def set_upcase
    Methods.field_upcase(params[:sub_topic])
  end    

  def set_sub_topic
    @sub_topic = SubTopic.find(params[:id])
  end

  def sub_topic_params
    params.require(:sub_topic).permit(:description, :topic_id, :description_project, :description_topic)
  end

  def show_project_topic(id) 
    description_project_topic = Topic.joins(project: :company)
                                      .where("company_id = ? and topics.id = ?", current_user.company.id, id)
                                      .pick('projects.description', 'topics.description')

    @sub_topic.description_project = description_project_topic[0]
    @sub_topic.description_topic = description_project_topic[1]    
  end

end
