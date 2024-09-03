class CreateTags < ActiveRecord::Migration[6.1]
  def change
    create_table :tags do |t|
      t.string :description, limit: 30, null: false
      t.bigint :project_id, null: false

      t.timestamps
    end
    
    add_foreign_key :tags, :projects, index: true
    add_index :tags, [:project_id, :description] , unique: true    
  end
end
