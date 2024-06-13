class Company < ApplicationRecord
  has_many :customers
  has_many :users
end
