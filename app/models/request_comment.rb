class RequestComment < ApplicationRecord
  has_rich_text :content

  belongs_to :request
  belongs_to :user
end
