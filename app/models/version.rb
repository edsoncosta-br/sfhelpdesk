class Version < ApplicationRecord
  validates :description, presence: true, length: {maximum: 30}
  validate :system_isempty
  validate :description_isempty  
  validates :description, uniqueness: { scope: :system_id, message: "já está em uso para o sistema selecionado." }

  belongs_to :system

  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end

  def system_isempty
    if self.system_id.blank?
      errors.add(:_, '_system_isempty_')
    end
  end  

end
