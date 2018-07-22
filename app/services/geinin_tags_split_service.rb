class GeininTagsSplitService

    def initialize(geinin_tag_param,geinin_id_param)
        @geinin_id = geinin_id_param
        @geinin_tag_param = geinin_tag_param
        @geinin_tags = @geinin_tag_param.to_h['0']["tag"]
    end

    def execute        
        # 改行コードで分割して、改行分レコードを作成する
    	@geinin_tags_list = @geinin_tags.split("\r\n")

        # 1回消して、もう1回登録する
        EventPerformer.where(event_id: @event_id).delete_all
        
        @event_performer_list.each do |performer|
            # 登録する
            EventPerformer.create(event_id: @event_id, performer: performer)
        end
        
    end
end