class SearchGeininByKeywordService

    def initialize(keyword_param)
        @keyword = keyword_param
    end

    def execute
        
        # 名前、事務所のいずかにキーワードが含まれる

        # タグにキーワードが含まれる
        geinins_by_keyword = Geinin.default.where("(name LIKE(?)) OR (agency LIKE (?))" , "%#{@keyword}%" , "%#{@keyword}%")
        geinins_by_tag = Geinin.default.where('geinin_tags.tag LIKE (?)', "%#{@keyword} %")
        
        # メンバータグにキーワードが含まれる
        geinins_by_member_tag = Geinin.default.where('geinin_member_tags.tag LIKE (?)', "%#{@keyword}%")
        
        geinins = geinins_by_keyword + geinins_by_tag + geinins_by_member_tag
        
        @results = geinins, nil,@keyword,nil
    end
end