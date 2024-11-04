class Ajuda::ArtigoController < ApplicationController
  layout 'help'

  def show
    @help = Help.select( :id,:title, :project_id, :user_created_id, 
                         :user_updated_id, :created_at, :updated_at,
                         'projects.description project_description',
                         'users.nick_name user_created_name',
                         "user_updateds_helps.nick_name user_updated_name",)
                  .joins(project: :company)
                  .joins(:user_created)
                  .left_joins(:user_updated)
                  .where("helps.id = ?", params[:id])
    
    @help_tag_ids = HelpTag.where("help_id = ?", params[:id]).pluck("tag_id")
  end
end