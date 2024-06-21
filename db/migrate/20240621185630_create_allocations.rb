class CreateAllocations < ActiveRecord::Migration[6.1]
  def change
    create_table :allocations do |t|
      t.bigint :user_id, null: false
      t.bigint :system_id, null: false
      t.boolean :main, default: false  

      t.timestamps
    end

    add_foreign_key :allocations, :systems, index: true, on_delete: :cascade, null: false  
    add_foreign_key :allocations, :users, index: true, on_delete: :cascade, null: false  
    add_index :allocations, [:system_id, :user_id] , unique: true
  end
end
