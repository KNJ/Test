class EventPerformer < ApplicationRecord
  belongs_to :event
  validates :event_id, presence: true
  validates :performer, presence: true
end
