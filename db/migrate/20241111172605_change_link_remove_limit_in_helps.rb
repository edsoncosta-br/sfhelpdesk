class ChangeLinkRemoveLimitInHelps < ActiveRecord::Migration[6.1]
  def change
    change_column :helps, :link, :string
  end
end
