class CreateSubTopics < ActiveRecord::Migration[6.1]
  def change
    create_table :sub_topics do |t|
      t.string :description, limit: 30, null: false
      t.bigint :topic_id, null: false

      t.timestamps
    end

    add_foreign_key :sub_topics, :topics, index: true, on_delete: :cascade, null: false  
    add_index :sub_topics, [:topic_id, :description] , unique: true
  end
end
