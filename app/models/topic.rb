class Topic < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :posts, dependent: :destroy

  validates :title, presence: true, length: { maximum: 200 }
  validates :body, presence: true

  def authored_by?(u)
    u && user_id == u.id
  end
end
