class HelpsController < ApplicationController
  before_action :set_help, only: %i[ edit update destroy ]

  def index
    helps = Help.select(:title, :link, :project_id, :user_created_id, :user_updated_id)
                .joins(project: :company)
                .joins(:user_created)
                .joins(:user_updated)
                .joins("INNER JOIN action_text_rich_texts ON action_text_rich_texts.record_id = helps.id AND record_type = 'Helps'")
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

  private

  def set_help
    @help = Help.find(params[:id])
  end

  def help_params
    params.require(:help).permit(:title, :link, :project_id, :user_created_id, :user_updated_id)
  end

end
