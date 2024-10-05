class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  has_many :comments, as: :commentable, dependent: :destroy
  belongs_to :user

  validates :review, presence: true
  validates :commentable, presence: true
  validates :user, presence: true

  scope :replies, ->(comment_id) { where(commentable_id: comment_id, commentable_type: "Comment").order(created_at: :desc) }
end
