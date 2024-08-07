class CreateMarks < ActiveRecord::Migration[6.1]
  def change
    create_table :marks do |t|
      t.string :description, limit: 30, null: false
      t.datetime :due_date
      t.datetime :release_date 
      t.bigint :project_id, null: false      

      t.timestamps
    end

    add_foreign_key :marks, :projects, index: true
    add_index :marks, [:project_id, :description] , unique: true
  end
end
