class CreateVersions < ActiveRecord::Migration[6.1]
  def change
    create_table :versions do |t|
      t.string :description, limit: 30, null: false
      t.datetime :due_date
      t.datetime :release_date 
      t.bigint :system_id, null: false      

      t.timestamps
    end

    add_foreign_key :versions, :systems, index: true
    add_index :versions, [:system_id, :description] , unique: true
  end
end
