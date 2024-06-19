class TopicsController < ApplicationController
  before_action :set_topic, only: %i[ edit update destroy ]

  def index
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = Topic.new(topic_params)
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path, notice: "Tópico cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to topics_path, notice: "Tópico atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @topic.destroy
        redirect_to topics_path, notice: "Tópico excluído com sucesso."
      else
        redirect_to topics_path
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to topics_path
    end
  end    

  def search
    topics = Topic.select(:id, :description, 'systems.description system_description')
                  .joins(system: :company)
                  .where("company_id = ?", current_user.company.id)
            .order(Arel.sql('unaccent(systems.description), unaccent(topics.description)'))

    if !params[:search_system].empty?
      topics = topics.where('systems.id = ?', "#{params[:search_system]}")
    end

    if !params[:search_description].empty?
      topics = topics.where('unaccent(topics.description) ilike unaccent(?)', "%#{params[:search_description]}%")
    end

    @topics = topics.all.page(params[:page]).per(Constants::PAGINAS)
    @topics_size = topics.size


    sub_topics = SubTopic.select(:id, :description, :topic_id)
                          .joins(topic: [{ system: :company }])
                          .where("company_id = ?", current_user.company.id)    
                          .order(Arel.sql('unaccent(sub_topics.description)'))

    @sub_topics = sub_topics.all

    respond_to do |format|
      format.js
    end  
  end  

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:description, :color,  :system_id)
  end  

end
