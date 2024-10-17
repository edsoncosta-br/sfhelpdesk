class AddDescriptionToMark < ActiveRecord::Migration[6.1]
  def change
    add_column :marks, :description_complement, :string, limit: 60
    add_column :marks, :closed, :boolean, default: false  
  end
end
