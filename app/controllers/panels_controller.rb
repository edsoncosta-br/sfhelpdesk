class PanelsController < ApplicationController
  def index
    @projects = Allocation.select('projects.id', :description)
                          .joins(:project)
                          .joins(project: :company)
                          .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
                          .order("main desc, unaccent(description)")
  end
end

