class CreateHelpTags < ActiveRecord::Migration[6.1]
  def change
    create_table :help_tags do |t|
      t.bigint :help_id, null: false
      t.bigint :tag_id, null: false      

      t.timestamps
    end

    add_foreign_key :help_tags, :helps, index: true, on_delete: :cascade, null: false  
    add_foreign_key :help_tags, :tags, index: true
    add_index :help_tags, [:help_id, :tag_id] , unique: true    
  end
end
