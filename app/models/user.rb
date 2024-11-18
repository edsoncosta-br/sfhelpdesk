class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def name_display
    if self.nick_name.empty?
      Methods.name_capitalize(self.name, true)
    else
      Methods.name_capitalize(self.nick_name, false)
    end
  end

  def amount_projects
    Allocation.where("user_id = ?", self.id).size
  end

  validates :email, presence: true, length: {maximum: 60}
  validates :name, presence: true, length: {maximum: 60}
  validates :nick_name, presence: true, length: {maximum: 20}
  validates :company_id, presence: true

  validate :email_isempty
  validate :name_isempty  
  validate :nick_name_isempty  

  belongs_to :position, required: false
  belongs_to :company

  has_many :allocations
  has_many :request_comments

  has_many :user_created_requests, class_name: 'Request', foreign_key: 'user_created_id'
  has_many :user_responsible_requests, class_name: 'Request', foreign_key: 'user_responsible_id'
  has_many :user_updated_requests, class_name: 'Request', foreign_key: 'user_updated_id'
  has_many :user_finished_requests, class_name: 'Request', foreign_key: 'user_finished_id'
  has_many :user_archived_requests, class_name: 'Request', foreign_key: 'user_archived_id'

  has_many :user_created_helps, class_name: 'Help', foreign_key: 'user_created_id'
  has_many :user_updated_helps, class_name: 'Help', foreign_key: 'user_updated_id'  

  has_one_attached :avatar
  validates :avatar, content_type: %i[png jpg jpeg], size: { less_than: 5.megabytes }  

  def active_for_authentication?
    super && active
  end  

  private

  def email_isempty
    if self.email.blank?
      errors.add(:_, '_email_isempty_')
    end
  end
  
  def name_isempty
    if self.name.blank?
      errors.add(:_, '_name_isempty_')
    end
  end

  def nick_name_isempty
    if self.nick_name.blank?
      errors.add(:_, '_nick_name_isempty_')
    end
  end  
  
  def position_isempty
    if self.position_id.blank?
      errors.add(:_, '_position_isempty_')
    end
  end  
  
end
