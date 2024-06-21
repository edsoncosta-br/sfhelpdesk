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

end
