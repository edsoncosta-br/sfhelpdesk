module UsersHelper
  def system_checked(user_id, system_id)
    if Allocation.select(:id).where('user_id = ? and system_id = ?', user_id, system_id).empty?
      ''
    else
      ', checked' 
    end  
  end
end