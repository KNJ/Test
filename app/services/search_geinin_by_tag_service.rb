class SearchGeininByTagService

    def initialize(tag_param)
        @tag = tag_param
    end

    def execute
        # タグが一致する
        @geinins = Geinin.default.where(geinin_tags: { tag: @tag } ) 
        @results = @geinins, nil,@tag,nil
    end
end