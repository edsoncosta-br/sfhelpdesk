class CreateTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :topics do |t|
      t.string :description, limit: 30, null: false
      t.string :color, limit: 7
      t.bigint :project_id, null: false

      t.timestamps
    end

    add_foreign_key :topics, :projects, index: true
    add_index :topics, [:project_id, :description] , unique: true
  end
end
