class AddEDatesToRequests < ActiveRecord::Migration[6.1]
  def change
    add_column :requests, :finished_date, :datetime
    add_column :requests, :archived_date, :datetime
  end
end
