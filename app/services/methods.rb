class Methods
  
  def self.files_allowed
    'jpeg, png, tiff, zip, rar, pdf, txt, ret, ofx e xml'
  end
  
  def self.format_date (param_date, type)
    if type == 'date_start'
      (param_date + ' 00:00:00 -0300').to_datetime.utc
    else type == 'date_end'
      (param_date + ' 23:59:59 -0300').to_datetime.utc
    end
  end

  def self.name_capitalize(name, first_name)
    if first_name == true
      name.capitalize().split()[0]
    else
      name.split(" ").map do |word| 
        if !['da', 'de','do', 'das', 'des', 'dos'].include? word.downcase
          word.capitalize
        else
          word.downcase
        end
      end.join " "
    end
  end

  def self.batch_number_f(batch_number)
    batch_number.to_s.rjust(5, '0')
  end

  def self.field_upcase(params) 
    # params.each do |param|
    #   params[param[0].to_sym] = params[param[0].to_sym].to_s.upcase if  (param[0] != "email") and 
    #                                                                     (param[0] != "email_admin") and 
    #                                                                     (param[0] != "files")
    # end
  end

  def self.select_allocations(company_id, current_user_id)
    Allocation.joins(:project)
              .joins(project: :company)
              .where("company_id = ? and allocations.user_id = ?", company_id, current_user_id)
              .order("main desc, unaccent(description)")
              .pick('projects.id')    
  end

  def self.get_tags(request_id)
    RequestTag.select(:description)
              .joins(:tag)
              .where("request_id = ?", request_id)
              .order("request_tags.id")
  end  

  def self.request_data(request_id)
    Request.select(:id, :title, :status, :step, :priority, 
                                  :customer_id, :code, :requester_name,
                                  :user_created_id, :user_responsible_id, 
                                  :mark_id, :created_date,
                                  "coalesce(marks.due_date, requests.due_date) dues_date",
                                  "projects.description projects_description",
                                  "users.nick_name user_created_name",
                                  "user_responsibles_requests.nick_name user_responsible_name",
                                  "marks.description mark_description",
                                  "customers.name customers_name")
              .joins(project: :company)
              .joins(:user_created)
              .left_joins(:user_responsible)
              .left_joins(:mark)
              .left_joins(:customer)
              .where("requests.id = ?", request_id)
  end  

end