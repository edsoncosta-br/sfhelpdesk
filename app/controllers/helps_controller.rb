class HelpsController < ApplicationController
  before_action :set_help, only: %i[ edit update destroy ]

  def index
    helps = Help.select(:id,:title, :link, :project_id, :user_created_id, 
                        :user_updated_id, :created_at, :updated_at, :slug,
                        'projects.description project_description',
                        'users.nick_name user_created_name',
                        "user_updateds_helps.nick_name user_updated_name",)
                .joins(project: :company)
                .joins(:user_created)
                .left_joins(:user_updated)
                .joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = helps.id AND record_type = 'Help'")
                .where("users.company_id = ?", current_user.company.id)

    # default params
    if params[:q_sys].blank?
      params[:q_sys] = Methods.select_allocations(current_user.company.id, current_user.id)

      if params[:q_sys].blank?
        params[:q_sys] = 0
      end                                  
    end
   
    if params[:q_order].blank?
      params[:q_order] = 'newest'
    end

    # filters
    helps = helps.where('projects.id = ?', "#{params[:q_sys]}")

    if !params[:q_content].blank?
      helps = helps.where('(unaccent(title) ilike unaccent(?) or unaccent(action_text_rich_texts.body) ilike unaccent(?))', 
                          "%#{params[:q_content]}%", 
                          "%#{params[:q_content]}%")
    end
   
    @helps = helps.all.page(params[:page]).per(Constants::PAGINAS)
    @helps_size = helps.size
  end

  def show
    @helps = Help.select( :id, :title, :link, :project_id, :user_created_id, 
                          :user_updated_id, :created_at, :updated_at, :slug,
                          'projects.description project_description',
                          'users.nick_name user_created_name',
                          "user_updateds_helps.nick_name user_updated_name",)
                  .joins(project: :company)
                  .joins(:user_created)
                  .left_joins(:user_updated)
                  .where("helps.slug = ?", params[:id])

    @help_tag_ids = HelpTag.joins(:help).where("helps.slug = ?", params[:id]).pluck("tag_id")                      
  end  

  def new
    @help = Help.new
    @help.project_id = params[:q_sys]
  end

  def create
    @help = Help.new(help_params)
    @help.user_created_id = current_user.id
    @help.link = "..."
   
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @help.save
          update_tag_ids(false)
          format.html { redirect_to helps_path( q_sys: params[:q_sys],
                                                q_content: params[:q_content]), 
                                                notice: "Ajuda cadastrada com sucesso." }
        else
          format.html { render :new, status: :unprocessable_entity }
          # @help.tag_ids = params[:tag_ids];
          @help.tag_ids = params[:tag_ids_selected].split;
        end
      end
    end
  end

  def edit
    @help.tag_ids = HelpTag.where("help_id = ?", @help.id).pluck("tag_id")
  end

  def update
    ActiveRecord::Base.transaction do
      @help.user_updated_id = current_user.id
      if @help.update(help_params)
        update_tag_ids(true)
        redirect_to help_path(@help,q_sys: params[:q_sys],
                                    q_content: params[:q_content]), 
                                    notice: "Ajuda atualizada com sucesso."
      else
        # @help.tag_ids = params[:tag_ids];
        @help.tag_ids = params[:tag_ids_selected].split;
        render :edit
      end
    end
  end

  def destroy
    begin
      if @help.destroy
        redirect_to helps_path( q_sys: params[:q_sys],
                                q_content: params[:q_content]), 
                                notice: "Ajuda excluída com sucesso."
      else
        redirect_to helps_path( q_sys: params[:q_sys],
                                q_content: params[:q_content])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to helps_path( q_sys: params[:q_sys],
                              q_content: params[:q_content])
    end
  end  

  private

  def set_help
    @help = Help.friendly.find(params[:id])
  end

  def update_tag_ids(updated)
    if updated
      help_tag = HelpTag.where("help_id = ?", @help.id)
      help_tag.delete_all
    end

    if params[:tag_ids_selected]
      params[:tag_ids_selected].split.each do |tag_id|
        HelpTag.create!(help_id: @help.id, tag_id: tag_id)
      end
    end    
  end

  def help_params
    params.require(:help).permit( :title, :link, :project_id, :user_created_id, :slug,
                                  :user_updated_id, :content, tag_ids: [])
  end

end

# Help.find_each(&:save)