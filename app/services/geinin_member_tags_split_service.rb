class GeininMemberTagsSplitService

    def initialize(geinin_member_tag_param,geinin_id_param,geinin_member_id_param)
        @geinin_id = geinin_id_param
        @geinin_member_id = geinin_member_id_param
        @geinin_member_tag_param = geinin_member_tag_param
        @geinin_member_tags = @geinin_member_tag_param.to_h['0']["tag"]
    end

    def execute        
        # 改行コードで分割して、改行分レコードを作成する
    	@geinin_member_tags_list = @geinin_member_tags.split("\r\n")

        # 1回消して、もう1回登録する
        GeininMemberTag.where(geinin_id: @geinin_id, geinin_member_id: @geinin_member_id).delete_all
        
        @geinin_member_tags_list.each do |member_tag|
            # 登録する
            GeininMemberTag.create(geinin_id: @geinin_id, geinin_member_id: @geinin_member_id, tag: member_tag)
        end
        
    end
end