require "test_helper"

class Comments::CheckEventCommentsTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers
  def setup
    @user = users(:one)
    @other_user = users(:two)
    @event = events(:one)
    @other_event = events(:two)
  end

  test "should not allow user to review their own event" do
    service = Comments::CheckEventComments.new(@event.id, "Event", @event.user)
    assert_equal "You cannot review your own event.", service.call
  end

  test "should not allow user to review event they did not attend" do
    service = Comments::CheckEventComments.new(@event.id, "Event", @other_user)
    assert_equal "You must have attended the event to leave a review.", service.call
  end

  test "should return false for non-event commentable type" do
    service = Comments::CheckEventComments.new(@event.id, "NonEvent", @user)
    assert_not service.call
  end
end
