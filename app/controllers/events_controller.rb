class EventsController < ApplicationController

	def new
		@event = Event.new
	end

	def create
        # ストロングパラメーターを使用
         @event = Event.new(event_params)

        # イベントが登録・編集されたら、変更履歴テーブルを更新
        event = Event.find_by(params[:event_id])
        event_change_history = event_change_histroies.build(event_id: event.id)

        #ユーザーがログインしていたら、ユーザーIDを変更履歴に保存
        logged_in?

        # ユーザーのipアドレスを保存
         event_change_histories.user_ip = request.remote_ip

        event_change_history.save

        # エラーチェック＆DB保存→詳細画面へリダイレクト
        if @event.save
            redirect_to "/events/#{@event.id}" , notice: 'ありがとうございます！ライブ登録が完了しました！'
        else
            flash.now[:error] = 'ライブ登録に失敗しました...。お手数ですが最初からやり直してください。'
            render :new
        end
    end

    def index
        #今日と明日の日付を取得
        require 'date'
        @today = Date.today
        @tomorrow = @today + 1

        @q = Event.ransack(params[:q])
    	@events = Event.page(params[:page]).reverse_order
    end

    def search
        binding.pry

        return @events = SearchDateKeywordService.new(params[:date],params[:keyword]).execute if params[:date].present? && params[:keyword].present?
        return @events = SearchKeywordService.new(params[:keyword]).execute if params[:keyword].present?
        return @events = SearchDateService.new(params[:date]).execute if params[:date].present?

        respond_to do |format|
          format.html # index.html.erb
        end
    end

    def today
       respond_to do |format|
          format.html # index.html.erb
        end
    end

    def show
    	@event = Event.find_by(params[:id])
    end

    def edit
    	@event = Event.find_by(params[:id])
    end

    def update
    	@event = Event.find_by(params[:id])

        #ユーザーがログインしていたら、ユーザーIDを変更履歴に保存
        logged_in?

        # ユーザーのipアドレスを取得
         @event.event_change_histories.user_ip = request.remote_ip

        @event.update(event_params)
        redirect_to event_path(params[:id])
    end

    def destroy
		@event = Event.find_by(params[:id])
        @event.destroy
        redirect_to events_path
    end

	private
    #ライブ情報
    def event_params
        params.require(:event).permit(:id,:date, :start, :title, :description, :tel, :email, :image,event_links_attributes: [:id, :event_id, :url],event_change_histories_attributes: [:id, :event_id, :user_id, :user_ip], event_performers_attributes: [:id, :event_id, :performer],event_categories_attributes: [:id,:event_id, :category])
    end

    #ユーザー情報
    def user_params
        params.require(:user).permit(:id, :name, :profile_image, :uid, :email, :password)
    end

    #検索クエリ
    def search_params
        params.require(:keyword).permit(:live_name_or_remarks_cont)
        params.require(:date).permit(:live_date_eq)
        params.require(:date_and_keyword).permit
    end
end