class Post < ApplicationRecord
  PER_PAGE = 10

  belongs_to :user
  belongs_to :topic, counter_cache: true

  validates :body, presence: true

  def authored_by?(u)
    u && user_id == u.id
  end
end
