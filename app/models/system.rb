class System < ApplicationRecord
  validates :description, presence: true, length: {maximum: 60}
  validate :description_isempty

  belongs_to :company
  
  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end    
end
