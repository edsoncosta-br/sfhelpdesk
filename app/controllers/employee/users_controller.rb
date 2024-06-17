class Employee::UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update destroy ]

  def index
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    @user.password = Constants::DEFAULT_PASSWORD
    @user.password_confirmation = Constants::DEFAULT_PASSWORD    
    @user.company_id = current_user.company_id
    
    respond_to do |format|
      if @user.save
        format.html { redirect_to employee_users_path, notice: "Usuário cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to employee_users_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit
    end      
  end

  def destroy
    begin
      if @user.destroy
        redirect_to employee_users_path, notice: "Usuário excluído com sucesso."
      else
        render :index
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to employee_users_path
    end
  end  

  def search
    users = User.select(:id, :email, :nick_name, :name, :active, :admin, 'positions.description position_description')
                .joins(:position)
                .where("company_id = ?", current_user.company.id)
                .order(Arel.sql('unaccent(users.name)'))

    if !params[:search_name].empty?
      users = users.where('unaccent(users.name) ilike unaccent(?)', "%#{params[:search_name].upcase}%")
    end

    @users = users.all.page(params[:page]).per(Constants::PAGINAS)
    @users_size = users.size

    respond_to do |format|
      format.js
    end  
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :name, :nick_name, :company_id, :position_id, :active)
  end    

end