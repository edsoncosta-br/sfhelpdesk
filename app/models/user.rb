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
end
