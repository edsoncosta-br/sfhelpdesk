class Request < ApplicationRecord

  validate :title_isempty
  validate :created_date_isempty
  validate :status_isempty
  validate :step_isempty
  validate :priority_isempty
  validate :project_id_isempty
  validate :user_created_id_isempty
  validate :topic_id_isempty

  belongs_to :customer
  belongs_to :project
  belongs_to :user_created_id, class_name: 'User'
  belongs_to :user_responsible_id, class_name: 'User'
  belongs_to :mark
  belongs_to :topic
  belongs_to :sub_topic

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

  def priority_isempty
    if self.priority.blank?
      errors.add(:_, '_priority_isempty_')
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

  def topic_id_isempty  
    if self.topic_id.blank?
      errors.add(:_, '_topic_id_isempty_')
    end        
  end

end
