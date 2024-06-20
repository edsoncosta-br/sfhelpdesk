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

  def self.get_sub_topics(topic_id, company_id )
    SubTopic.select(:id, :description, :topic_id)
              .joins(topic: [{ system: :company }])
              .where("company_id = ? and topic_id = ?", company_id, topic_id)
              .order(Arel.sql('unaccent(sub_topics.description)'))
  end

end