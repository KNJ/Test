class Event < ApplicationRecord
	attachment :image

	#一人のユーザーが複数のライブを「参加する」としてマークできる
  has_many :participates, dependent: :destroy

	#一人のユーザーが複数のライブを「気になる」としてマークできる
  has_many :pendings, dependent: :destroy

  #一つのライブ記事が複数のリンクを持てる
  has_many :event_links, dependent: :destroy
  accepts_nested_attributes_for :event_links, allow_destroy: true,reject_if: :all_blank

  #一つのライブ記事が複数の変更履歴を持てる
  has_many :event_change_histories, dependent: :destroy
  accepts_nested_attributes_for :event_change_histories, allow_destroy: true,reject_if: :all_blank

  #一つのライブ記事が複数の出演者を持てる
  has_many :event_performers, dependent: :destroy
  accepts_nested_attributes_for :event_performers, allow_destroy: true,reject_if: :all_blank

  #一つのライブ記事が複数のカテゴリを持てる
  has_many :event_categories, dependent: :destroy
  accepts_nested_attributes_for :event_categories, allow_destroy: true,reject_if: :all_blank

  #存在チェック
  validates :datetime, presence: true
  validates :title, presence: true

  # デフォルトの検索順序
    # 日付の昇順に並べ換える
      scope :order_by_datetime, -> { order(datetime: :asc) }
    # 常に本日以降の日付を表示する
      scope :display_after_today, -> { where(arel_table[:datetime].gt Time.zone.now) }
    # 子テーブルを常にInclude
      scope :including_event_info, -> { includes(:event_performers, :event_categories, :event_links, :participates, :pendings)
                                .references(:event_performers, :event_categories, :event_links, :participates, :pendings) } 
    # 上記3つをまとめる
      scope :default, ->{ order_by_datetime.display_after_today.including_event_info }
    
  #　参加するになってるかチェック
  def participated_by?(event,user)
    participates.where(event_id: event.id, user_id: user.id).exists?
  end

  # 検討中になってるかチェック
  def pending_by?(event,user)
    pendings.where(event_id: event.id,user_id: user.id).exists?
  end

  # リンクの件数をチェック
  def how_many_urls?(event)
    event_links.where(event_id: event.id).count
  end

  def user_signed_in?
        # Returns true if the user is logged in, false otherwise.
        !current_user.nil?
  end

  # 日付で検索
  def self.datetime_search(from,to)
      Event.default.where(datetime: from..to)
  end

  # 出演者で検索
  def self.performer_search(performer)
    #　芸人情報を取得
    geinin = Geinin.default.where(name: performer)
    geinin_id = geinin.pluck(:id)

    # 出演者の個人名を取得する
    members_name = GeininMember.where(geinin_id: geinin_id).pluck(:family_name)
    
    # 芸人が個人で出演する場合のライブ情報も検索に含める
    performers_list = []
    performers_list << performer

    members_name.each do |member_name|
      performer_member = performer+member_name
      performers_list << performer_member
      performer_member = ""
    end
    
    binding.pry

    # 出演者が一致するイベントIDを取得
    event_ids = Event.default.where(event_performers: { performer: [performers_list] } ).pluck(:id).uniq                 

    # イベントの全出演者を取得するため、もう1回idでイベントを検索
    @events = Event.default.where(id: event_ids)
  end

  def self.performer_search_count(performer)
    @event_count = Event.performer_search(performer).count
  end

    def self.lumine_urls
        links = []
        month = 1

        #1月〜12月分のURLを取得
        while month <= 12 do
          if month <= 9
            links << ("http://www.yoshimoto.co.jp/lumine/schedule0"+ "#{month}"+".php")
          else
            links << ("http://www.yoshimoto.co.jp/lumine/schedule"+"#{month}"+".php")
          end
          month = month + 1
        end

        links.each do |lumine_url|
            get_lumine(lumine_url)
        end
    end

    #ルミネのページをスクレイピング
    def self.get_lumine(link)
        lumine = Mechanize.new
        page = lumine.get(lumine_url)

        schedule_part = page.search('#schedule_pc')
        eles = schedule_part.search('ul')

        eles.each do |ele|
          if ele.search('#dayTitle').present?
            day = ele.search('#dayTitle').inner_text
          else
            day = Event.last.day
          end
          title = ele.search('li .schedule_con, .lastChild')[1].inner_text
          description = ele.search('li .schedule_con, .lastChild')[0].inner_text

          place = '¥nルミネtheよしもと¥n'
          price = ele.search('li .schedule_con, .lastChild')[4].inner_text
          performers_list = ele.search('li .schedule_con, .lastChild')[2].inner_text
          detail = ele.search('li .schedule_con, .lastChild')[3].inner_text

          remarks = place+price+"¥n"+performers_list+details

          event = Event.where(live_name: title, day: day, starting_time: starting_time, remarks: remarks).first_or_create

          #performers = performers_list.gsub(/\r\n|\s/,"").gsub(/\[.*?\]/,"／").split("／").reject(&:blank?)
          #performers.each do |name|
          #  performer = Performer.where(name: name).first_or_create
          #  live.performers << performer
          #end
        end
    end
end