class SearchEventPerformerService

    def initialize(performer_param)
        @performer = performer_param
    end

    def execute
     
        #　芸人情報を取得
        @geinin = Geinin.default.where(name: @performer)
        @geinin_id = @geinin.pluck(:id)

        # 出演者の個人名を取得する
        @members_name = GeininMember.where(geinin_id: @geinin_id).pluck(:family_name)
        
        # 芸人が個人で出演する場合のライブ情報も検索に含める
        @performers = ""
        
        @members_name.each do |member_name|
            @performer_member = @performer.concat(member_name)
            @performers = @performers + @performer_member
        end

        # 出演者とキーワードが一致するイベントIDを取得
        @event_ids = Event.default.where(event_performers: { performer: "#{Event.escape_like(@performers)}"} ).pluck(:id)                   

        # 全出演者を取得するため、もう1回idでイベントを検索
        @events = Event.default.where(id: @event_ids.uniq)
       
        @results = @events, nil,@performer,@geinin
    end
end