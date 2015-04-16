class User < ActiveRecord::Base

  has_many :filedets ,dependent: :destroy
  has_many :homes ,dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
end
