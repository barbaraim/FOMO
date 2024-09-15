require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  setup do
    sign_in users(:one)
    @event = events(:future_event)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "should create event" do
    visit events_url
    click_on "New event"

    fill_in "Address", with: @event.address
    fill_in "Description", with: @event.description
    fill_in "End date", with: @event.end_date
    fill_in "Name", with: @event.name
    fill_in "Start date", with: @event.start_date
    click_on "Save"

    assert_text "Event was successfully created"
  end

  test "should update Event" do
    visit event_url(@event)
    click_on "Edit this event", match: :first

    fill_in "Address", with: "new address"
    fill_in "Description", with: "new description"
    fill_in "End date", with: "10-10-2200 19:04:13"
    fill_in "Name", with: "New Name"
    fill_in "Start date", with: "10-10-2150 19:04:13"
    click_on "Save"

    assert_text "Event was successfully updated"
  end
end
