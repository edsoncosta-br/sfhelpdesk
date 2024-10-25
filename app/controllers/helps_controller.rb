class HelpsController < ApplicationController
  before_action :set_help, only: %i[ edit update destroy ]

  def index
    helps = Help.select(:id,:title, :link, :project_id, :user_created_id, 
                        :user_updated_id, :created_at, :updated_at,
                        'projects.description project_description',
                        'users.nick_name user_created_name',
                        "user_updateds_helps.nick_name user_updated_name",)
                .joins(project: :company)
                .joins(:user_created)
                .left_joins(:user_updated)
                .joins("LEFT JOIN action_text_rich_texts ON action_text_rich_texts.record_id = helps.id AND record_type = 'Helps'")
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

  def new
    @help = Help.new
    @help.project_id = params[:q_sys]
  end

  def create
    @help = Help.new(help_params)
    @help.user_created_id = current_user.id
    
    respond_to do |format|
      ActiveRecord::Base.transaction do
        if @help.save
          # update_tag_ids(false)
          format.html { redirect_to helps_path( q_sys: params[:q_sys],
                                                q_content: params[:q_content]), 
                                                notice: "Requisição cadastrada com sucesso." }
        else
          format.html { render :new, status: :unprocessable_entity }
          @help.tag_ids = params[:tag_ids];
        end
      end
    end
  end  

  private

  def set_help
    @help = Help.find(params[:id])
  end

  def update_tag_ids(updated)
    if updated
      help_tag = HelpTag.where("help_id = ?", @help.id)
      help_tag.delete_all
    end

    if params[:tag_ids]
      params[:tag_ids].each do |tag_id|
        HelpTag.create!(help_id: @help.id, tag_id: tag_id)
      end
    end    
  end  

  def help_params
    params.require(:help).permit( :title, :link, :project_id, :user_created_id, 
                                  :user_updated_id, :content, tag_ids: [])
  end

end
