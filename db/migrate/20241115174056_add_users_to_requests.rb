class AddUsersToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :user_finished_id, :integer
    add_column :requests, :user_archived_id, :integer
  end
end
