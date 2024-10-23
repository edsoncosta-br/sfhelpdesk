class Help < ApplicationRecord

  belongs_to :project
  belongs_to :user_created, class_name: 'User', :foreign_key => 'user_created_id'
  belongs_to :user_updated, class_name: 'User', required: false, :foreign_key => 'user_updated_id'


end
