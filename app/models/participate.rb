class Participate < ApplicationRecord
	belongs_to :user
	belongs_to :event

	validates :user_id, presence: true
	validates :event_id, presence: true
	
	#1ユーザー1回まで
	validates_uniqueness_of :event_id, scope: :user_id
end