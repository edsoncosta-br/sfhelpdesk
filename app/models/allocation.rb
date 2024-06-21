class Allocation < ApplicationRecord
  validate :user_isempty
  validate :system_isempty  
  validates :user_id, uniqueness: { scope: :system_id, message: "já está alocado no sistema selecionado." }

  belongs_to :system
  belongs_to :user

  private

  def user_isempty
    if self.user_id.blank?
      errors.add(:_, '_user_isempty_')
    end
  end    

  def system_isempty
    if self.system_id.blank?
      errors.add(:_, '_system_isempty_')
    end
  end  
end
