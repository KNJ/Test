class GeininMemberTag < ApplicationRecord
	belongs_to :geinin_member
	validates :geinin_id, presence: true
	validates :geinin_member_id, presence: true
	validates :tag, presence: true
end
