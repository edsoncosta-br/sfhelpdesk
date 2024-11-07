class AddSlugToHelps < ActiveRecord::Migration[6.1]
  def change
    add_column :helps, :slug, :string
    add_index :helps, :slug, unique: true
  end
end
