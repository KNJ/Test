class SearchEventPlaceService

    def initialize(place_param)
        @place = place_param
    end

    def execute
        # 場所が一致する
        @events = Event.default.where(place: @place ) 
        @results = @events, nil,@place
    end
end