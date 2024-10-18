class CreateRequestTags < ActiveRecord::Migration[6.1]
  def change
    create_table :request_tags do |t|
      t.bigint :request_id, null: false
      t.bigint :tag_id, null: false

      t.timestamps
    end

    add_foreign_key :request_tags, :requests, index: true, on_delete: :cascade, null: false  
    add_foreign_key :request_tags, :tags, index: true
    add_index :request_tags, [:request_id, :tag_id] , unique: true    
  end
end
