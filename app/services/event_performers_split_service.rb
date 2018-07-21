class EventPerformersSplitService

    def initialize(event_performer_param,event_id)
        @event_id = event_id
        @event_performer_param = event_performer_param
        @event_performer = @event_performer_param.to_h['0']["performer"]
    end

    def execute        
        # 改行コードで分割して、改行分レコードを作成する
    	@event_performer_list = @event_performer.split("\r\n")


        # 1回消して、もう1回登録する
        EventPerformer.where(event_id: @event_id).delete_all
        
        @event_performer_list.each do |performer|
            # 登録する
            EventPerformer.create(event_id: @event_id, performer: performer)
        end
        
    end
end