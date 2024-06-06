class ApplicationController < ActionController::Base
  # solve error ActionController::InvalidAuthenticityToken
  protect_from_forgery with: :null_session  

  before_action :authenticate_user!  
end
