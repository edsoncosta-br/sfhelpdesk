class CreateSystems < ActiveRecord::Migration[6.1]
  def change
    create_table :systems do |t|
      t.string :description, limit: 60, null: false
      t.boolean :active, default: true
      t.bigint :company_id, null: false

      t.timestamps
    end
    
    add_foreign_key :systems, :companies, index: true
  end
end
