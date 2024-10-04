class CreateRequestComments < ActiveRecord::Migration[6.1]
  def change
    create_table :request_comments do |t|
      t.datetime :created_date, null: false
      t.bigint :user_id, null: false
      t.bigint :request_id, null: false

      t.timestamps
    end
    
    add_foreign_key :request_comments, :requests, index: true, on_delete: :cascade, null: false  
    add_foreign_key :request_comments, :users, index: true, null: false  
  end
end
