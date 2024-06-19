class SubTopic < ApplicationRecord
  validates :description, presence: true, length: {maximum: 30}
  validate :topic_isempty
  validate :description_isempty
  validates :description, uniqueness: { scope: :topic_id, message: "já está em uso para o tópico selecionado." }

  belongs_to :topic

  attr_accessor :description_system
  attr_accessor :description_topic
  
  private

  def description_isempty
    if self.description.blank?
      errors.add(:_, '_description_isempty_')
    end
  end

  def topic_isempty
    if self.topic_id.blank?
      errors.add(:_, '_topic_isempty_')
    end
  end  
end
