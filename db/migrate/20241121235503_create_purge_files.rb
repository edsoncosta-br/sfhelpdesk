class CreatePurgeFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :purge_files do |t|
      t.datetime :purge_date

      t.timestamps
    end
  end
end
