class User < ApplicationRecord
  ROLES = %w[member moderator administrator].freeze

  has_secure_password

  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true, length: { minimum: 2, maximum: 30 }
  validates :role, inclusion: { in: ROLES }

  def admin?
    role == "administrator"
  end

  def moderator?
    role == "moderator"
  end

  def staff?
    admin? || moderator?
  end
end
