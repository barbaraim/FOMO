class Participant < ApplicationRecord
  belongs_to :user
  has_one :event

  enum participant_status: { attending: 0, interested: 1, declined: 2 }
end
