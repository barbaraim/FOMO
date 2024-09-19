require "test_helper"

class ParticipantTest < ActiveSupport::TestCase
  setup do
    @user = users(:two)
    @event = events(:one)
    @future_event = events(:future_event)
  end

  test "should not allow user to participate twice in the same event" do
    Participant.create(participant_status: :attending, notify: true, event: @future_event, user: @user)
    duplicate_participant = Participant.new(user: @user, event: @future_event)
    assert_not duplicate_participant.valid?
    assert_includes duplicate_participant.errors.full_messages, "User can't participate twice in the same event."
  end

  test "should not allow user to participate in own event" do
    author_user = users(:one)
    participant = Participant.new(user: author_user, event: @future_event)
    assert_not participant.valid?
    assert_includes participant.errors.full_messages, "User can't participate in own event."
  end

  test "should not allow user to participate in past event" do
    past_event = events(:past_event)
    participant = Participant.new(user: @user, event: past_event)
    assert_not participant.valid?
    assert_includes participant.errors[:event], "is in the past."
  end
end
