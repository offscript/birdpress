class Comment < ApplicationRecord
  belongs_to :micropost
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :micropost_id, presence: true
  validates :body, presence: true
  validates :title, presence: true
  #length validation
  
end
