class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name, limit: 60, null: false
      t.boolean :active, default: true      

      t.timestamps
    end
  end
end
