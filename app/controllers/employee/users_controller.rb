class Employee::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]
  before_action :set_permission_admin_menu

  def index
    users = User.select(:id, :email, :nick_name, :name, :active, 
                        :admin, :permission_admin_menu, 'positions.description position_description')
                .left_outer_joins(:position)
                .where("users.company_id = ?", current_user.company.id)
                .order(Arel.sql('unaccent(users.name)'))

    if !params[:q_name].blank?
      users = users.where('unaccent(users.name) ilike unaccent(?)', "%#{params[:q_name]}%")
    end

    if !params[:q_position].blank?
      users = users.where('users.position_id = ?', "#{params[:q_position]}")
    end    

    @users = users.all.page(params[:page]).per(Constants::PAGINAS)
    @users_size = users.size    
  end

  def new
    @user = User.new
    get_projects
  end

  def create
    @user = User.new(user_params)

    @user.password = Constants::DEFAULT_PASSWORD
    @user.password_confirmation = Constants::DEFAULT_PASSWORD    
    @user.company_id = current_user.company_id
    
    respond_to do |format|
      if @user.save
        save_userprojects
        format.html { redirect_to employee_users_path(q_name: params[:q_name], 
                                                      q_position: params[:q_position]), 
                                                      notice: "Usuário cadastrado com sucesso." }
      else
        get_projects
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    get_projects
  end

  def update
    # Using a temporary variable allows us to save the parameters into a variable that we can then modify
    updated_params = user_params
    if @user.admin
      updated_params[:permission_admin_menu] = true
      updated_params[:active] = true
    end

    if @user.update(updated_params)
      save_userprojects
      redirect_to employee_users_path(q_name: params[:q_name], 
                                      q_position: params[:q_position]), 
                                      notice: "Usuário atualizado com sucesso."
    else
      get_projects
      render :edit
    end      
  end

  def destroy
    begin
      if @user.destroy
        redirect_to employee_users_path(q_name: params[:q_name], 
                                        q_position: params[:q_position]), 
                                        notice: "Usuário excluído com sucesso."
      else
        render :index
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to employee_users_path(q_name: params[:q_name], 
                                      q_position: params[:q_position])
    end
  end  

  private

  def set_user
    @user = User.find(params[:id])
  end

  def get_projects
    @projects = Project.select(:id, :description)
                        .where('company_id = ?', current_user.company_id) 
                        .order(Arel.sql('unaccent(description)'))
  end

  def user_params
    params.require(:user).permit( :email, :name, :nick_name, :company_id, :position_id, 
                                  :active, :admin, :permission_admin_menu, :permission_request)
  end

  def save_userprojects
    Allocation.where('user_id = ?', @user.id).destroy_all

    if params['projectcheck']
      params['projectcheck'].each do |project_id, checked|

        if params['projectmain']
          projectmain = params['projectmain'][project_id] == '1'
        else
          projectmain = false
        end

        if checked == '1' #true
          Allocation.create!(user_id: @user.id, project_id: project_id, main: projectmain )
        end
      end
    end
  end

  def set_permission_admin_menu
    permission_admin_menu    
  end  

end