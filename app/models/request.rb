class Request < ApplicationRecord
  has_many_attached :files

  validate :title_isempty
  validate :created_date_isempty
  validate :status_isempty
  validate :step_isempty
  validate :project_id_isempty
  validate :user_created_id_isempty
  validates :files, size: { less_than: 3.megabytes }    
  
  belongs_to :customer, required: false
  belongs_to :project

  belongs_to :user_created, class_name: 'User', :foreign_key => 'user_created_id'
  belongs_to :user_responsible, class_name: 'User', required: false, :foreign_key => 'user_responsible_id'
  belongs_to :user_updated, class_name: 'User', required: false, :foreign_key => 'user_updated_id'
  belongs_to :user_finished, class_name: 'User', required: false, :foreign_key => 'user_finished_id'
  belongs_to :user_archived, class_name: 'User', required: false, :foreign_key => 'user_archived_id'

  belongs_to :mark, required: false

  has_many :request_tags
  has_many :request_comments

  attr_accessor :tag_ids
  attr_reader :new_files  

  has_rich_text :content
  
  def any_attached?
    ActiveStorage::Attachment.where(record_type: 'Request', record_id: id).any?
  end

  def count_attached
    ActiveStorage::Attachment.where(record_type: 'Request', record_id: id).count
  end

  def any_comment?
    self.request_comment.any?
  end

  # add attachments without deleting previous ones on every update
  def new_files=(files)
    self.files.attach(files)
  end  

  private

  def title_isempty
    if self.title.blank?
      errors.add(:_, '_title_isempty_')
    end    
  end

  def created_date_isempty
    if self.created_date.blank?
      errors.add(:_, '_created_date_isempty_')
    end        
  end

  def status_isempty
    if self.status.blank?
      errors.add(:_, '_status_isempty_')
    end        
  end

  def step_isempty
    if self.step.blank?
      errors.add(:_, '_step_isempty_')
    end        
  end

  def project_id_isempty
    if self.project_id.blank?
      errors.add(:_, '_project_id_isempty_')
    end        
  end

  def user_created_id_isempty
    if self.user_created_id.blank?
      errors.add(:_, '_user_created_id_isempty_')
    end        
  end

end
