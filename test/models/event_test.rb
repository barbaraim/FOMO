require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "bring only past events in past events scope" do
    assert_equal 3, Event.past.count
  end

  test "bring only future events in past events scope" do
    assert_equal 1, Event.upcoming.count
  end

  test "bring only happening now events in past events scope" do
    assert_equal 1, Event.happening_now.count
  end

  test "bring only happening now and future events in past events scope" do
    assert_equal 2, Event.now_and_upcoming.count
  end
end
