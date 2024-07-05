class Allocation < ApplicationRecord
  validate :user_isempty
  validate :project_isempty  
  validates :user_id, uniqueness: { scope: :project_id, message: "já está alocado no Projeto selecionado." }

  belongs_to :project
  belongs_to :user

  private

  def user_isempty
    if self.user_id.blank?
      errors.add(:_, '_user_isempty_')
    end
  end    

  def project_isempty
    if self.project_id.blank?
      errors.add(:_, '_project_isempty_')
    end
  end  
end
