class Position < ApplicationRecord
  validates :description, presence: true, length: {maximum: 30}
  validates :description, uniqueness: true
  validate :description_isempty

  has_many :users

  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end    
end
