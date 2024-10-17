class ProjectsController < ApplicationController
  before_action :set_project, only: %i[ edit update destroy show ]
  before_action :set_permission_admin_menu
  before_action :set_upcase, only: %i[ create update ]  

  def index
    projects = Project.order(Arel.sql('unaccent(description)'))

    if !params[:q_desc].blank?
      projects = projects.where('unaccent(description) ilike unaccent(?)', "%#{params[:q_desc]}%")
    end    

    @projects = projects.all.page(params[:page]).per(Constants::PAGINAS)
    @projects_size = projects.size    
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    @project.company_id = current_user.company.id    
    
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path(q_desc: params[:q_desc]), notice: "Projeto cadastrado com sucesso." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def show
  end

  def update
    if @project.update(project_params)
      redirect_to projects_path(q_desc: params[:q_desc]), notice: "Projeto atualizado com sucesso."
    else
      render :edit
    end      
  end  

  def destroy
    begin
      if @project.destroy
        redirect_to projects_path(q_desc: params[:q_desc]), notice: "Projeto excluído com sucesso."
      else
        redirect_to projects_path(q_desc: params[:q_desc])
      end
    rescue StandardError => e

      if e.message.downcase.to_s.include? "foreignkeyviolation"
        flash[:error] = "Este registro já está sendo usado e não pode ser excluído!"
      else  
        flash[:error] = e.message[0...80] + "..."
      end

      redirect_to projects_path(q_desc: params[:q_desc])
    end
  end

  def filter_project_dependency
    if !params[:request][:project_id].empty?
      @marks = Mark.select(:id, :description).order('unaccent(description)').
                    where('project_id = ?', params[:request][:project_id]);
    else
      @marks = ''
    end

    if !params[:request][:project_id].empty?
      @users_responsible = Allocation.select('users.id', 'users.nick_name')
                                      .joins(:user)
                                      .joins(user: :company)
                                      .where("company_id = ? and allocations.project_id = ?", current_user.company.id, params[:request][:project_id])
                                      .order("unaccent(users.nick_name)")
    else
      @users_responsible = ''
    end    
  end    

  private
  
  def set_upcase
    Methods.field_upcase(params[:project])
  end  

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:description)
  end    

  def set_permission_admin_menu
    permission_admin_menu    
  end
  
end
