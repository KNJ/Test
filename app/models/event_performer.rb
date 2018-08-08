class EventPerformer < ApplicationRecord
  belongs_to :event
  validates :performer, presence: true
end
