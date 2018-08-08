class EventCategory < ApplicationRecord
  belongs_to :event
  validates :category, presence: true
end
