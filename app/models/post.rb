class Post < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  validates :body, presence: true

  def authored_by?(u)
    u && user_id == u.id
  end
end
