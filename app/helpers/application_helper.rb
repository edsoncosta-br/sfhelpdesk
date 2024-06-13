module ApplicationHelper

  def is_invalid(resource, msg) 
    if resource.errors.any? 
      "is-invalid" if resource.errors.to_a.to_s.include? msg  
    end  
  end

  def is_disabled(action)
    (action == "edit") or (action == "update") ? true : false
  end

end
