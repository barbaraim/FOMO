class Event < ApplicationRecord
  belongs_to :user

  scope :upcoming, -> { where("start_date >= ?", Date.today) }
  scope :past, -> { where("end_date < ?", Date.today) }
  scope :happening_now, -> { where("start_date <= ? AND end_date >= ?", Date.today, Date.today) }
  scope :now_and_upcoming, -> { where("end_date >= ?", Date.today) }
end
