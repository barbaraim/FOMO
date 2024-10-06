class Event < ApplicationRecord
  belongs_to :user
  has_many :participants, dependent: :destroy, class_name: "Participant", foreign_key: "event_id"
  has_many :comments, as: :commentable, dependent: :destroy

  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where.not(archived: true) }
  scope :upcoming, -> { where("start_date >= ?", Date.today).not_archived }
  scope :past, -> { where("end_date < ?", Date.today).not_archived }
  scope :happening_now, -> { where("start_date <= ? AND end_date >= ?", Date.today, Date.today).not_archived }
  scope :now_and_upcoming, -> { where("end_date >= ?", Date.today).not_archived }

  validates :name, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :address, presence: true, length: { minimum: 5 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :past_event_when_deleting, on: :destroy
  validate :archive_only_past_events, on: :update

  def end_date_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "must be after the start date")
    end
  end

  def past_event_when_deleting
    return if end_date.blank?

    if end_date < Date.today || (start_date < Date.today && end_date > Date.today)
      errors.add("Event", "can't be deleted because it's in the past or happening now.")
    end
  end

  def archive_only_past_events
    return if end_date.blank? || archived == false

    if end_date >= Date.today
      errors.add(:archived, "can only be set to true for past events.")
    end
  end

  def pretty_start_date
    start_date.to_time.strftime("%B %e %Y at %l:%M %p")
  end

  def pretty_end_date
    end_date.to_time.strftime("%B %e %Y at %l:%M %p")
  end
end
