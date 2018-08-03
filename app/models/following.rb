class Following < ApplicationRecord
  belongs_to :user
  belongs_to :geinin

	validates :user_id, presence: true
  validates :geinin_id, presence: true
  
	#1ユーザー1回まで
	validates_uniqueness_of :geinin_id, scope: :user_id
end
