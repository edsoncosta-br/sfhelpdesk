class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.string :description, limit: 60, null: false
      t.boolean :active, default: true
      t.bigint :company_id, null: false

      t.timestamps
    end
    
    add_foreign_key :projects, :companies, index: true
  end
end
