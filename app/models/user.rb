class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :timeoutable, :jwt_authenticatable, jwt_revocation_strategy: self
  has_many :events
  has_many :participants, dependent: :destroy, class_name: "Participant", foreign_key: "user_id"
  has_many :comments, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"
end
