class GeininTag < ApplicationRecord
	belongs_to :geinin
	validates :tag, presence: true
end
