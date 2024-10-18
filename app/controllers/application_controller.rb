class ApplicationController < ActionController::Base
  # solve error ActionController::InvalidAuthenticityToken
  protect_from_forgery with: :null_session  

  before_action :authenticate_user!

  def menu_admin
    if !current_user.menu_admin?
      flash[:error] = "Acesso negado"
      redirect_to root_path
    end
  end

end
