require "test_helper"

class EventTest < ActiveSupport::TestCase
  # test scopes
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

  # test validations
  test "should not save event without information" do
    event = Event.new(description: "Description 1", address: "Address 1", start_date: Date.yesterday, end_date: Date.tomorrow, user_id: users(:one).id)
    assert_not event.save
    assert_includes event.errors.full_messages, "Name can't be blank"
  end

  test "should not save event with inconsistent start and end dates" do
    event = Event.new(name: "Event 1", description: "Description 1", address: "Address 1", start_date: Date.tomorrow, end_date: Date.yesterday, user_id: users(:one).id)
    assert_not event.save
    assert_includes event.errors.full_messages, "End date must be after the start date"
  end

  test "should not archive future event" do
    event = events(:future_event)
    event.archived = true
    assert_not event.save
    assert_includes event.errors.full_messages, "Archived can only be set to true for past events."
  end
end
