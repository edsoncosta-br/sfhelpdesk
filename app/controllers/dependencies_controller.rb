class DependenciesController < ApplicationController
  def project_responsible
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
end