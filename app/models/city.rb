class City < ApplicationRecord
  validates :name, presence: true, length: {maximum: 50}
  has_many :customers  
end
