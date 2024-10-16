module ApplicationHelper

  def is_invalid(resource, msg) 
    if resource.errors.any? 
      "is-invalid" if resource.errors.to_a.to_s.include? msg  
    end  
  end

  def enable_by_action(action)
    (action == "edit") or (action == "update") or (action == "show") ? true : false
  end  

  def enable_by_permission(action)
    (@user.admin or action == "show")  ? true : false
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

  def btn_caption(disable)
    disable ? 'Retornar' : 'Cancelar'
  end

  def disable_check(disable)
    if disable
      "disabled"
    end
  end

  def delete_not_allowed
    ('<span data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="Sem permissão">
      <i class="fa-regular fa-trash-can pe-1 unavailable-icon"></i>
    </span>').html_safe
  end

  def edit_not_allowed
    ('<span data-bs-toggle="tooltip" data-bs-placement="top" data-bs-title="Sem permissão">
      <i class="fa-regular fa-pen-to-square pe-1 unavailable-icon"></i>
    </span>').html_safe
  end  

  def index_title(description)
    ('<i class="icon-style fa-solid fa-angles-right pe-2"></i><div>' + description + '</div>').html_safe
  end

  def form_select_project_allocations(selected)
    options_from_collection_for_select( Allocation.select('projects.id', :description)
                                                  .joins(:project)
                                                  .joins(project: :company)
                                                  .where("company_id = ? and allocations.user_id = ?", current_user.company.id, current_user.id)
                                                  .order("unaccent(description)"),
                                                  :id, :description, selected)
  end

  def form_select_user_allocation(project_id, selected)
    options_from_collection_for_select( Allocation.select('users.id', 'users.nick_name')
                                                  .joins(:user)
                                                  .joins(user: :company)
                                                  .where("company_id = ? and allocations.project_id = ?", current_user.company.id, project_id)
                                                  .order("unaccent(users.nick_name)"),
                                                  :id, :nick_name, selected)
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
    options_from_collection_for_select( Customer.select(:id, :name, "LPAD(CAST(customers.code AS varchar), 4, '0' ) || '-' || customers.name name")
                                                .where("company_id = ?", current_user.company.id)
                                                .order("unaccent(name)"), 
                                                :id, :name, selected)
  end

  def form_select_mark(project_id, selected)
    options_from_collection_for_select( Mark.select(:id, :description)
                                            .where("project_id = ?", project_id)
                                            .order("unaccent(description)"), 
                                            :id, :description, selected)
  end

  def form_select_tag(project_id, selected)
    options_from_collection_for_select(Tag.select(:id, :description)
                                          .where("project_id = ?", project_id)
                                          .order("unaccent(description)"), 
                                          :id, :description, selected)
  end  

  def form_select_project_tags(project_id)
    options_from_collection_for_select( Tag.select(:id, :description)
                                            .where("project_id = ?", project_id)
                                            .order("unaccent(description)"), 
                                            :id, :description)
  end  

end
