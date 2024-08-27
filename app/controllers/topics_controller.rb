class TopicsController < ApplicationController
  before_action :set_topic, only: %i[ edit update destroy ]
  before_action :set_upcase, only: %i[ create update ]    

  def index
    topics = Topic.select(:id, :description, 'projects.description project_description')
                  .joins(project: :company)
                  .where("company_id = ?", current_user.company.id)
            .order(Arel.sql('unaccent(projects.description), unaccent(topics.description)'))

    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end

    topics = topics.where('projects.id = ?', "#{params[:q_sys]}")    

    if !params[:q_desc].blank?
      topics = topics.where('unaccent(topics.description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end

    @topics = topics.all.page(params[:page]).per(Constants::PAGINAS)
    @topics_size = topics.size    
  end

  def new
    @topic = Topic.new
    @topic.project_id = params[:q_sys]    
  end

  def create
    @topic = Topic.new(topic_params)
    
    respond_to do |format|
      if @topic.save
        format.html { redirect_to topics_path(q_sys: params[:q_sys],
                                              q_desc: params[:q_desc]), notice: "Tópico cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      redirect_to topics_path(q_sys: params[:q_sys],
                              q_desc: params[:q_desc]), notice: "Tópico atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @topic.destroy
        redirect_to topics_path(q_sys: params[:q_sys],
                                q_desc: params[:q_desc]), notice: "Tópico excluído com sucesso."
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

  def set_upcase
    Methods.field_upcase(params[:topic])
  end    

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:description, :color,  :project_id)
  end  

end
