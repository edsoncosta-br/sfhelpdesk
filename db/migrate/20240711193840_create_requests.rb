class CreateRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :requests do |t|
      t.string :title, limit: 100, null: false
      t.datetime :created_date, null: false
      t.datetime :due_date
      t.integer :status, null: false
      t.integer :step, null: false
      t.boolean :priority, default: false  
      t.string :requester_name, limit: 30
      t.integer :customer_id
      t.integer :project_id, null: false
      t.integer :user_created_id, null: false
      t.integer :user_responsible_id
      t.integer :mark_id

      t.timestamps
    end

    add_foreign_key :requests, :customers, index: true
    add_foreign_key :requests, :projects, index: true
    add_foreign_key :requests, :users, index: true, column: :user_created_id
    add_foreign_key :requests, :users, index: true, column: :user_responsible_id
    add_foreign_key :requests, :marks, index: true
  end
end
