class CreateHelps < ActiveRecord::Migration[6.1]
  def change
    create_table :helps do |t|
      t.string :title, limit: 100, null: false
      t.string :link, limit: 100
      t.integer :project_id, null: false
      t.integer :user_created_id, null: false
      t.integer :user_updated_id

      t.timestamps
    end

    add_foreign_key :helps, :projects, index: true
    add_foreign_key :helps, :users, index: true, column: :user_created_id
    add_foreign_key :helps, :users, index: true, column: :user_updated_id
  end
end
