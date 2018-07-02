class Geinin < ApplicationRecord
	has_many :geinin_members, dependent: :destroy
	has_many :geinin_tags, dependent: :destroy

  #存在チェック
    validates :name, presence: true
    validates :yomi, presence: true

  # あいうえお順の昇順に並べ換える
    scope :including_geinin_info, -> { includes(:geinin_members, :geinin_tags, :followings) => {:geinin_member_tags}
                .references(:geinin_members, :geinin_tags, :followings) => {:geinin_member_tags} }
  # あいうえお順の昇順に並べ換える
    scope :order_by_yomi, -> { order(yomi: :asc) }

    scope :default, -> { order_by_yomi.including_geinin_info}
end
