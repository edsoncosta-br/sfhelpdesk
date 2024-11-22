class DependenciesController < ApplicationController
  def project
    @marks = ''
    @users_responsible = ''
    @model_name = params[:model_name] 
    
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

    if (params[:model_name] == "request") or (params[:model_name] == "help")
      if !params[params[:model_name]][:project_id].empty?
        @tags = Tag.select(:id, :description).where("project_id = ?", params[params[:model_name]][:project_id]).order("unaccent(description)")
      else
        @tags = ''
      end
    end

    if (params[:model_name] == "request_search") or (params[:model_name] == "help_search")
      if !params[:q_sys].empty?
        @tags = Tag.select(:id, :description).where("project_id = ?", params[:q_sys]).order("unaccent(description)")
      else
        @tags = ''
      end
    end    

  end  
end