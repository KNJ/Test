class SearchKeywordService
    include ApplicationHelper

    def initialize(keyword_param)
        @keyword = keyword_param
    end

    def execute
        
        # タイトル、説明、会場のどれかにキーワードが含まれる
        @events_ids = Event.display_after_today.where("(title LIKE(?)) OR (description LIKE (?)
        ) OR (place LIKE(?))" , "%#{escape_like(@keyword)}%" , "%#{escape_like(@keyword)}%", "%#{escape_like(@keyword)}%").select(:id)

        # 出演者にキーワードが含まれる
        if Event.default.where('event_performers.performer like ?', "%#{escape_like(@keyword)}%").exists?
		    @events_ids = @events_ids + Event.default.where('event_performers.performer like ?', "%#{escape_like(@keyword)}%").select(:id)
		end

        # カテゴリにキーワードが含まれる
        if Event.default.where('event_categories.category like ?', "%#{escape_like(@keyword)}%").exists?
		    @events_ids = @events_ids + Event.default.where('event_categories.category like ?', "%#{escape_like(@keyword)}%").select(:id)
        end

        @events = Event.default.where(id:@events_ids)
        
        binding.pry

        @results = @events, nil,@keyword,nil
    end
end