class Help < ApplicationRecord
  after_commit  :set_link

  validates :title, presence: true
  validates :content, presence: true
  
  validate :content_isempty
  validate :title_isempty

  belongs_to :project
  belongs_to :user_created, class_name: 'User', :foreign_key => 'user_created_id'
  belongs_to :user_updated, class_name: 'User', required: false, :foreign_key => 'user_updated_id'

  attr_accessor :tag_ids

  has_rich_text :content

  private

  def title_isempty
    if self.title.blank?
      errors.add(:_, '_title_isempty_')
    end    
  end

  def content_isempty
    if self.content.blank?
      errors.add(:_, '_content_isempty_')
    end
  end    

  def set_link
    Help.where('id = ?', self.id).update_all(link: '/ajuda/topico/' + self.id.to_s)
  end  
end