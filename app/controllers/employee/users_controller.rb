class Employee::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    users = User.select(:id, :email, :nick_name, :name, :active, :admin, 'positions.description position_description')
                .left_outer_joins(:position)
                .where("company_id = ?", current_user.company.id)
                .order(Arel.sql('unaccent(users.name)'))

    if !params[:q_name].blank?
      users = users.where('unaccent(users.name) ilike unaccent(?)', "%#{params[:q_name]}%")
    end

    @users = users.all.page(params[:page]).per(Constants::PAGINAS)
    @users_size = users.size    
  end

  def new
    @user = User.new
    get_systems
  end

  def create
    puts params['systemcheck']

    @user = User.new(user_params)

    @user.password = Constants::DEFAULT_PASSWORD
    @user.password_confirmation = Constants::DEFAULT_PASSWORD    
    @user.company_id = current_user.company_id
    
    respond_to do |format|
      if @user.save
        save_usersystems
        format.html { redirect_to employee_users_path(q_name: params[:q_name]), notice: "Usuário cadastrado com sucesso." }
      else
        get_systems
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    get_systems
  end

  def update
    if @user.update(user_params)
      save_usersystems
      redirect_to employee_users_path(q_name: params[:q_name]), notice: "Usuário atualizado com sucesso."
    else
      get_systems
      render :edit
    end      
  end

  def destroy
    begin
      if @user.destroy
        redirect_to employee_users_path(q_name: params[:q_name]), notice: "Usuário excluído com sucesso."
      else
        render :index
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to employee_users_path(q_name: params[:q_name])
    end
  end  

  private

  def set_user
    @user = User.find(params[:id])
  end

  def get_systems
    @systems = System.select(:id, :description).
                      where('company_id = ?', current_user.company_id) 
                      .order(Arel.sql('unaccent(description)'))
  end

  def user_params
    params.require(:user).permit(:email, :name, :nick_name, :company_id, :position_id, :active)
  end

  def save_usersystems
    Allocation.where('user_id = ?', @user.id).destroy_all

    if params['systemcheck']
      params['systemcheck'].each do |system_id, checked|
        puts system_id
        puts checked
      end
    end    

    if params['systemcheck']
      params['systemcheck'].each do |system_id, checked|
        if checked == '1' #true
          Allocation.create!(user_id: @user.id, system_id: system_id)
        end
      end
    end
  end

end