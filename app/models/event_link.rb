class EventLink < ApplicationRecord
  belongs_to :event
  validates :url, presence: true
end
