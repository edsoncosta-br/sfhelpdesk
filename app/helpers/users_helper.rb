module UsersHelper
  def project_checked(user_id, project_id)
    if Allocation.select(:id).where('user_id = ? and project_id = ?', user_id, project_id).empty?
      ''
    else
      ', checked' 
    end  
  end

  def project_main(user_id, project_id)
    main = Allocation.select(:main).where('user_id = ? and project_id = ?', user_id, project_id).pick('main')

    if main
      ', checked' 
    else
      ''
    end
  end  
end