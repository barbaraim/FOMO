class Event < ApplicationRecord
  belongs_to :user

  scope :upcoming, -> { where("start_date >= ?", Date.today) }
  scope :past, -> { where("end_date < ?", Date.today) }
  scope :happening_now, -> { where("start_date <= ? AND end_date >= ?", Date.today, Date.today) }
  scope :now_and_upcoming, -> { where("end_date >= ?", Date.today) }

  validates :name, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 10, maximum: 500 }
  validates :address, presence: true, length: { minimum: 5 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date
  validate :past_event_when_deleting, on: :destroy

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
end
