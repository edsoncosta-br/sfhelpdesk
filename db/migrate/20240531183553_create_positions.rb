class CreatePositions < ActiveRecord::Migration[6.1]
  def change
    create_table :positions do |t|
      t.string :description, limit: 30, null: false

      t.timestamps
    end
  end
end
