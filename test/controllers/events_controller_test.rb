require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should redirect to login when getting new with no user" do
    get new_event_url
    assert_redirected_to new_user_session_url
  end

  test "should redirect when trying create event with no user" do
    assert_no_difference("Event.count") do
      post events_url, params: { event: { address: @event.address, description: @event.description, end_date: @event.end_date, name: @event.name, start_date: @event.start_date, user_id: @event.user_id } }
    end

    assert_redirected_to new_user_session_url
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should redirect when attempting to edit event without user" do
    get edit_event_url(@event)

    assert_redirected_to new_user_session_url
  end

  test "should redirect when attempting to update event without user" do
    patch event_url(@event), params: { event: { address: @event.address, description: @event.description, end_date: @event.end_date, name: @event.name, start_date: @event.start_date, user_id: @event.user_id } }

    assert_redirected_to new_user_session_url
  end

  test "should redirect when attempting to destroy event without user" do
    assert_no_difference("Event.count") do
      delete event_url(@event)
    end

    assert_redirected_to new_user_session_url
  end

  test "should get new when user is logged in" do
    sign_in users(:one)
    get new_event_url
    assert_response :success
  end

  test "should create event when user is logged in" do
    sign_in users(:one)
    assert_difference("Event.count") do
      post events_url, params: { event: { address: @event.address, description: @event.description, end_date: @event.end_date, name: @event.name, start_date: @event.start_date } }
    end

    assert_redirected_to event_url(Event.last)
    assert_equal users(:one).id, Event.last.user_id
  end

  test "should get edit" do
    sign_in users(:one)
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    sign_in users(:one)
    patch event_url(@event), params: { event: { address: @event.address, description: @event.description, end_date: @event.end_date, name: @event.name, start_date: @event.start_date, user_id: @event.user_id } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    sign_in users(:one)
    assert_difference("Event.count", -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end

  test "should redirect when attemping to edit event by other than author" do
    sign_in users(:two)
    get edit_event_url(@event)
    assert_redirected_to events_url
  end

  test "should redirect when attemping to update event by other than author" do
    sign_in users(:two)
    patch event_url(@event), params: { event: { address: @event.address, description: @event.description, end_date: @event.end_date, name: @event.name, start_date: @event.start_date, user_id: @event.user_id } }
    assert_redirected_to events_url
  end

  test "should redirect when attemping to destroy event by other than author" do
    sign_in users(:two)
    assert_no_difference("Event.count") do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
