class GeininTagsSplitService

    def initialize(geinin_tag_param,geinin_member_tag_parm,geinin_id_param)
        @geinin_id = geinin_id_param
        @geinin_tag_param = geinin_tag_param
        @geinin_member_tag_param = geinin_member_tag_param
        @geinin_tags = @geinin_tag_param.to_h['0']["tag"]
        @geinin_member_tags = @geinin_member_tag_param.to_h['0']["tag"]
    end

    def execute        
        # 改行コードで分割して、改行分レコードを作成する
        @geinin_tags_list = @geinin_tags.split("\r\n")
        @geinin_member_tags_list = @geinin_member_tags.split("\r\n")

        # 1回消して、もう1回登録する
        GeininTag.where(geinin_id: @geinin_id).delete_all
        GeininMemberTag.where(geinin_id: @geinin_id).delete_all
        
        # 芸人タグを登録する
        @geinin_tags_list.each do |tag|
            GeininTag.create(geinin_id: @geinin_id, tag: tag)
        end

        # 芸人メンバータグを登録する
        @geinin_member_tags_list.each do |tag|
            GeininMemberTag.create(geinin_id: @geinin_id, tag: tag)
        end
    end
end