class GeininMember < ApplicationRecord
  belongs_to :geinin
  has_many :geinin_member_tags, dependent: :destroy
  accepts_nested_attributes_for :geinin_member_tags, allow_destroy: true,reject_if: :all_blank

  scope :including_geinin_member_info, -> { includes(:geinin_members_tags).references(:geinin_member_tags)}

  validates :geinin_id, presence: true
  validates :family_name, presence: true
end
