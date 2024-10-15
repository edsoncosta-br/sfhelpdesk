class UpdateStepRequests < ActiveRecord::Migration[6.1]
  def change
    Request.update_all step: 2
  end
end
