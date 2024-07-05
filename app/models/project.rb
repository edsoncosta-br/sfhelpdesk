class Project < ApplicationRecord
  validates :description, presence: true, length: {maximum: 60}
  validate :description_isempty

  belongs_to :company
  has_many :topics
  has_many :marks
  has_many :allocations
  
  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end    
end
