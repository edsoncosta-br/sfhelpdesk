class Users::RegistrationsController < Devise::RegistrationsController
  # Allow users to edit their account without providing a password
  # An alternative solution would be to simply override the update_resource method in your registrations controller 
  # When using this solution you will need to tell devise to use your controller in routes.rb:
  # devise_for :users, controllers: { registrations: 'registrations' }
  # Source: Devise Wiki
  before_action :set_avatar_deleted, only: %i[ update ]

  def update
    # if user_params != nil
    #   if @user.update(user_params)
        
    #     if avatar_isempty
    #       @user.avatar.purge
    #     end

    #     redirect_to frontoffice_process_batches_path, notice: "Usuário atualizado com sucesso."
    #   else
    #     redirect_to edit_user_registration_path, notice: resource.errors.full_messages.to_sentence
    #   end
    # else
    #   redirect_to frontoffice_process_batches_path, notice: "Usuário atualizado com sucesso."
    # end
  end

  private

  def avatar_isempty
    params[:avatar_deleted].to_s.include? "emptyuser.png"
  end

  def set_avatar_deleted
    if avatar_isempty
      @user.avatar.attach(io: File.open(Rails.root + 'app/assets/images/emptyuser.png'), filename: 'emptyuser.png')
    end
  end

  def user_params
    if params[:user] != nil
      params.require(:user).permit(:avatar)
    end
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end
end