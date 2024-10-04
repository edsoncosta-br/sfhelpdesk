class CreateAllocations < ActiveRecord::Migration[6.1]
  def change
    create_table :allocations do |t|
      t.bigint :user_id, null: false
      t.bigint :project_id, null: false
      t.boolean :main, default: false  

      t.timestamps
    end

    add_foreign_key :allocations, :projects, index: true, on_delete: :cascade, null: false  
    add_foreign_key :allocations, :users, index: true, null: false  
    add_index :allocations, [:project_id, :user_id] , unique: true
  end
end
