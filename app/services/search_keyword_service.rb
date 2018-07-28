class SearchKeywordService

    def initialize(keyword_param)
        @keyword = keyword_param
    end

    def execute
        
        # タイトル、説明、会場のどれかにキーワードが含まれる
        @events = Event.default.where("(title LIKE(?)) OR (description LIKE (?)
        ) OR (place LIKE(?))" , "%#{Event.escape_like(@keyword)}%" , "%#{Event.escape_like(@keyword)}%", "%#{Event.escape_like(@keyword)}%")

        # 出演者にキーワードが含まれる
        if Event.default.where('event_performers.performer like ?', "%#{Event.escape_like(@keyword)}%").exists?
		    @events = @events + Event.default.where('event_performers.performer like ?', "%#{Event.escape_like(@keyword)}%")
		end

        # カテゴリにキーワードが含まれる
        if Event.default.where('event_categories.category like ?', "%#{Event.escape_like(@keyword)}%").exists?
		    @events = @events + Event.default.where('event_categories.category like ?', "%#{Event.escape_like(@keyword)}%")
        end
        
        @results = @events, nil,@keyword
    end
end