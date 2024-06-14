class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.integer :code, null: false
      t.string :name, limit: 100, default: "", null: false
      t.string :type_person, limit: 8
      t.string :cpfcnpj_number, limit: 18, null: false
      t.boolean :active, default: true
      t.string :address, limit: 50
      t.string :number, limit: 8
      t.string :complement, limit: 20
      t.string :district, limit: 30
      t.string :zip_code, limit: 9
      t.string :phone, limit: 15
      t.string :cellphone, limit: 15
      t.string :email, limit: 60
      t.boolean :code_typed, default: false
      t.bigint :city_id, null: false
      t.bigint :company_id, null: false

      t.timestamps
    end

    add_foreign_key :customers, :cities, index: true
    add_foreign_key :customers, :companies, index: true
  end
end
