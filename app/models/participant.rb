class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :participant_status, [ :attending, :interested, :declined ]

  validate :user_cannot_participate_twice, on: :create
  validate :cannot_participate_in_own_event, on: :create
  validate :cannot_participate_in_past_event, on: :create
  after_create_commit :notify_recipient

  def user_cannot_participate_twice
    if Participant.exists?(user_id: user_id, event_id: event_id)
      errors.add(:user, "can't participate twice in the same event.")
    end
  end

  def cannot_participate_in_own_event
    if Event.exists?(user_id: user_id, id: event_id)
      errors.add(:user, "can't participate in own event.")
    end
  end

  def cannot_participate_in_past_event
    if Event.find(event_id).end_date < Date.today
      errors.add(:event, "is in the past.")
    end
  end

  private

  def notify_recipient
    ParticipationNotifier.with(record: event, message: "#{user.name} is attending #{event.name}").deliver(event.user)
  end
end
