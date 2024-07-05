module UsersHelper
  def project_checked(user_id, project_id)
    if Allocation.select(:id).where('user_id = ? and project_id = ?', user_id, project_id).empty?
      ''
    else
      ', checked' 
    end  
  end
end