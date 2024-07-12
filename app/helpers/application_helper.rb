module ApplicationHelper

  def is_invalid(resource, msg) 
    if resource.errors.any? 
      "is-invalid" if resource.errors.to_a.to_s.include? msg  
    end  
  end

  def enable_by_action(action)
    (action == "edit") or (action == "update") ? true : false
  end  

  def enable_by_permission(enable)
    enable == true ? true : false
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

  def form_select_project_allocations(selected)
    options_from_collection_for_select( Allocation.select('projects.id', :description)
                                                  .joins(:project)
                                                  .joins(project: :company)
                                                  .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
                                                  .order("unaccent(description)"),
                                                  :id, :description, selected)
  end

  def form_select_city(state, selected)
    options_from_collection_for_select( City.select(:id, :name)
                                            .where("state = ?", state)
                                            .order("unaccent(name)"), 
                                            :id, :name, selected )
  end

  def form_select_position(selected)
    options_from_collection_for_select( Position.select(:id, :description)
                                                .where("company_id = ?", current_user.company.id)
                                                .order("unaccent(description)"), 
                                                :id, :description, selected)
  end

  def form_select_customer(selected)
    options_from_collection_for_select( Customer.select(:id, :name)
                                                .where("company_id = ?", current_user.company.id)
                                                .order("unaccent(name)"), 
                                                :id, :name, selected)
  end  

  def form_select_topic(project_id, selected)

    # if project_id.blank?
    #   project_id = Allocation.select('projects.id')
    #                           .joins(:project)
    #                           .joins(project: :company)
    #                           .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
    #                           .order("unaccent(description)")      
    # end

    options_from_collection_for_select( Topic.select(:id, :description)
                                              .where("project_id = ?", project_id)
                                              .order("unaccent(description)"), 
                                              :id, :description, selected)
  end    

end
