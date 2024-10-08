class AddUserPermissionRequest < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :permission_request, :boolean, default: false

    User.update_all permission_request: true
  end
end
