require "test_helper"

class Comments::CheckLevelTest < ActiveSupport::TestCase
  def setup
    @comment = comments(:one) # Assuming you have a fixture for comments
    @nested_comment = comments(:two) # Assuming this is a nested comment
  end

  test "should return true for non-commentable type" do
    service = Comments::CheckLevel.new(@comment.id, "Post", :create)
    assert service.call
  end

  test "should return false for show action on comment" do
    service = Comments::CheckLevel.new(@comment.id, "Comment", :show)
    assert_not service.call
  end

  test "should return false for nested comment" do
    service = Comments::CheckLevel.new(@nested_comment.id, "Comment", :create)
    assert_not service.call
  end

  test "should return true for top-level comment" do
    service = Comments::CheckLevel.new(@comment.id, "Comment", :create)
    assert service.call
  end
end
