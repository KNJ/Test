class Geinin < ApplicationRecord
  # 複数メンバーを持てる
  has_many :geinin_members, dependent: :destroy
  accepts_nested_attributes_for :geinin_members, allow_destroy: true,reject_if: :all_blank

  has_many :geinin_member_tags, through: :geinin_members
  accepts_nested_attributes_for :geinin_member_tags, allow_destroy: true,reject_if: :all_blank

  # 複数タグ付けできる
  has_many :geinin_tags, dependent: :destroy
  accepts_nested_attributes_for :geinin_tags, allow_destroy: true,reject_if: :all_blank

  # 複数フォローできる
  has_many :followings, dependent: :destroy
  accepts_nested_attributes_for :followings, allow_destroy: true,reject_if: :all_blank

  #存在チェック
  	validates :geinin_id, presence: true
    validates :name, presence: true
    validates :yomi, presence: true

  # あいうえお順の昇順に並べ換える
    scope :including_geinin_info, -> { includes(:geinin_members, :geinin_member_tags, :geinin_tags, :followings,geinin_members: :geinin_member_tags)
                .references(:geinin_members, :geinin_member_tags, :geinin_tags, :followings,geinin_members: :geinin_member_tags)}
  # あいうえお順の昇順に並べ換える
    scope :order_by_yomi, -> { order(yomi: :asc) }

    scope :default, -> { order_by_yomi.including_geinin_info }

    #　フォローするになってるかチェック
    def followed_by?(geinin,user)
      Following.where(geinin_id: geinin.id, user_id: user.id).exists?
    end

    # 読みがなの最初の文字で検索（あいうえお検索）
    def self.index_search(first_string)
      Geinin.default.where("(yomi LIKE(?))","#{first_string}%")
    end
end
