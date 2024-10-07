class RequestComment < ApplicationRecord
  validates :content, presence: true
  validate :content_isempty

  has_rich_text :content

  belongs_to :request
  belongs_to :user

  private

  def content_isempty
    if self.content.blank?
      errors.add(:_, '_content_isempty_')
    end
  end  
end
