module HelpsHelper
  def search_fields
    { q_sys: params[:q_sys], 
      q_content: params[:q_content] }
  end

  def value(field1, field2)
    params[field1].blank? ? '' : params[field1][field2]
  end
end
