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
        GeininTag.where(geinin_id: @geinin_id).delete_all
        
        @geinin_tags_list.each do |tag|
            # 登録する
            GeininTag.create(geinin_id: @geinin_id, tag: tag)
        end
        
    end
end