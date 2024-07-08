class ApplicationController < ActionController::Base
  # solve error ActionController::InvalidAuthenticityToken
  protect_from_forgery with: :null_session  

  before_action :authenticate_user!

  def permission_admin_menu
    if !current_user.permission_admin_menu?
      flash[:error] = "Acesso negado"
      redirect_to root_path
    end
  end
end
