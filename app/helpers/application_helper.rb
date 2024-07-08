module ApplicationHelper

  def is_invalid(resource, msg) 
    if resource.errors.any? 
      "is-invalid" if resource.errors.to_a.to_s.include? msg  
    end  
  end

  def is_disabled(action)
    (action == "edit") or (action == "update") ? true : false
  end

  def format_date(datetime)
    if datetime.present?
      datetime.strftime("%d/%m/%Y")
    else
      "..." 
    end
  end  

  def format_datetime(datetime)
    if datetime.present?
      datetime.strftime("%d/%m/%Y %H:%M")
    else
      "..." 
    end
  end

  def form_select_project_allocations
    # options_from_collection_for_select(Project.select(:id, :description)
    #                                           .joins(:company)
    #                                           .where("company_id = ?", current_user.company.id)
    #                                           .order("unaccent(description)"),
    #                                           :id, :description, params[:q_sys])

    options_from_collection_for_select( Allocation.select('projects.id', :description)
                                                  .joins(:project)
                                                  .joins(project: :company)
                                                  .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
                                                  .order("unaccent(description)"),
                                                  :id, :description, params[:q_sys])
  end

  def form_select_position
    options_from_collection_for_select( Position.select(:id, :description)
                                                .order("unaccent(description)"), 
                                                :id, :description, @user.position_id)
  end

  def form_select_city
    options_from_collection_for_select( City.select(:id, :name)
                                            .where("state = ?", @customer.state )
                                            .order("unaccent(name)"), 
                                            :id, :name, @customer.city_id )
  end  

end
