class CreateCities < ActiveRecord::Migration[6.1]
  def change
    create_table :cities do |t|
      t.string :name, limit: 50, null: false, default: ""
      t.integer :ibge_code
      t.string  :state      

      t.timestamps
    end
  end
end
