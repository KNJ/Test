class GeininTag < ApplicationRecord
	belongs_to :geinin
	validates :geinin_id, presence: true
	validates :tag, presence: true
end
