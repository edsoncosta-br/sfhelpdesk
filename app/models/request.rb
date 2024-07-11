class Request < ApplicationRecord

  belongs_to :customer
  belongs_to :project
  belongs_to :user_created_id, class_name: 'User'
  belongs_to :user_status_id, class_name: 'User'
  belongs_to :mark
  belongs_to :topic
  belongs_to :sub_topic

  private  

end
