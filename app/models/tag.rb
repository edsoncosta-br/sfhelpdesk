class Tag < ApplicationRecord
  validates :description, presence: true, length: {maximum: 30}
  validate :project_isempty
  validate :description_isempty
  validates :description, uniqueness: { scope: :project_id, message: "já está em uso para o projeto selecionado." }

  belongs_to :project
  has_many :request_tags
  # has_many :requests, through: :request_tags

  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end

  def project_isempty
    if self.project_id.blank?
      errors.add(:_, '_project_isempty_')
    end
  end  
end
