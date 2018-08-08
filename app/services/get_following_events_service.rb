class GetFollowingEventsService

    def initialize(user)
        @user = user
    end

    def execute
      # フォローしてる芸人のIDを取得する
      geinins = Geinin.default.where(followings: {user_id: @user.id})
      
      # 芸人の個人名を取得する
      geinins_members = GeininMember.where(geinin_id: geinins.pluck(:id).uniq)

      # 芸人が個人で出演する場合のライブ情報も検索に含める
      performers_list = []
      
      geinins.each do |geinin|
        geinin_id = geinin.id
        performers_list << geinin.name

        geinin_members_names = geinins_members.where(geinin_id: geinin.id).pluck(:family_name)

        geinin_members_names.each do |geinin_member_name|
          geinin_member = geinin.name+geinin_member_name
          performers_list << geinin_member
          geinin_member = ""
        end
      end

      # 出演者とキーワードが一致するイベントIDを取得
      @event_ids = Event.default.where(event_performers: { performer: [performers_list] }).pluck(:id).uniq              

      # 全出演者を取得するため、もう1回idでイベントを検索
      @events_followings = Event.default.where(id: [@event_ids]).uniq 
    end
end