class RequestTag < ApplicationRecord
  validate :request_isempty
  validate :tag_isempty  
  validates :tag_id, uniqueness: { scope: :request_id, message: "já está alocado na Requisição selecionada." }

  belongs_to :request
  belongs_to :tag

  private

  def tag_isempty
    if self.tag_id.blank?
      errors.add(:_, '_tag_isempty_')
    end
  end    

  def request_isempty
    if self.request_id.blank?
      errors.add(:_, '_request_isempty_')
    end
  end    
end
