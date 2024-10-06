class Comments::CheckLevel < ApplicationService
  def initialize(commentable_id, commentable_type, action)
    @commentable_id = commentable_id
    @commentable_type = commentable_type
    @action = action
  end

  def call
    if @commentable_type == "Comment"
      return false if @action == :show
      commented_comment = Comment.find(@commentable_id)
      if commented_comment.commentable_type == "Comment"
        return false
      end
    end
    true
  end
end
