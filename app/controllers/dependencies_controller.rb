class DependenciesController < ApplicationController
  def project
    @marks = ''
    @users_responsible = ''
    
    if params[:model_name] == "request" 
      if !params[params[:model_name]][:project_id].empty?
        @marks = Mark.select(:id, :description).order('unaccent(description)').
                      where('project_id = ?', params[params[:model_name]][:project_id]);
      end

      if !params[params[:model_name]][:project_id].empty?
        @users_responsible = Allocation.select('users.id', 'users.nick_name')
                                        .joins(:user)
                                        .joins(user: :company)
                                        .where("company_id = ? and allocations.project_id = ?", current_user.company.id, params[params[:model_name]][:project_id])
                                        .order("unaccent(users.nick_name)")
      end
    end      

    if !params[params[:model_name]][:project_id].empty?
      @tags = Tag.select(:id, :description).where("project_id = ?", params[params[:model_name]][:project_id]).order("unaccent(description)")
    else
      @tags = ''
    end 

  end  
end