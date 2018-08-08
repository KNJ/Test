class GetFollowingEventsService

    def initialize(user)
        @user = user
    end

    def execute
      # フォローしてる芸人のIDを取得する
      geinins = Geinin.default.where(followings: {user_id: @user.id})

      # 芸人の個人名を取得する
      # members_names = GeininMember.where(geinin_id: geinin_ids).pluck(:family_name)
      
      # 芸人が個人で出演する場合のライブ情報も検索に含める
      performers = ""
      
      geinins.each do |geinin|
        geinin_id = geinin.id
        geinin_name = geinin.name

        # performers = ""

        # geinin_members_names.each do |geinin_member_name|
        #   geinin_member = geinin_name.concat(geinin_member_name)
        #   perormers = performers + geinin_member
        # end
        performers = performers + geinin_name
      end

      # 出演者とキーワードが一致するイベントIDを取得
      @event_ids = Event.default.where(event_performers: { performer: performers }).pluck(:id)                 

      # 全出演者を取得するため、もう1回idでイベントを検索
      @events_followings = Event.default.where(id: @event_ids.uniq).uniq      
    end
end