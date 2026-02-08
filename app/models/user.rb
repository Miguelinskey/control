class User < ApplicationRecord
  has_secure_password

  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 2, maximum: 30 }
end
