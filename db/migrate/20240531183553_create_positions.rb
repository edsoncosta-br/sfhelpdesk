class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :description, limit: 60, null: false
      t.bigint :company_id, null: false

      t.timestamps
    end

    add_index :positions, :description, unique: true
    add_foreign_key :positions, :companies, index: true
  end
end
