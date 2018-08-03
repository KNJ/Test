class EventLink < ApplicationRecord
  belongs_to :event
  validates :event_id, presence: true
  validates :url, presence: true
end
