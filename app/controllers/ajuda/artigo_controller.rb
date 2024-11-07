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
                  .where("slug = ?", params[:id])
    
    @help_tag_ids = HelpTag.joins(:help).where("slug = ?", params[:id]).pluck("tag_id")
  end
end

# /ajuda/artigo/sffiscal-sfcontabil-como-verificar-a-seguranca-dos-seus-e-mails-na-caixa-de-entrada-do-gmail