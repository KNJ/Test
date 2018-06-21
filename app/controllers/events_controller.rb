class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :edit, :destroy]
  before_action :set_current_user, only: [:index, :show, :update, :edit, :destroy]
  before_action :set_remote_ip, only: [:create, :update]

  def new
      # イベントを登録
        @event = Event.new

      # 出演者を登録
        @event.event_performers.build

      # リンクを登録
        @event.event_links.build

      # カテゴリを登録
        @event.event_categories.build

  end

  def create
        # イベント情報を取得
         @event = Event.new(event_params)

        # Event_performersを1行ごとのレコードに分ける
         #EventPerformersSplitService.new(event_params).execute

        # DB保存→詳細画面へリダイレクト
        if @event.save
            # イベントが登録されたら、変更履歴テーブルを更新
            UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute

            redirect_to event_path(@event.id), notice: 'ありがとうございます！ライブ登録が完了しました！'
        else
            if @event[:title].blank?
              flash.now[:error] = 'タイトルを入力してください'
            elsif @event[:datetime].blank?
              flash.now[:error] = '開催日時を入力してください'
            end
            flash.now[:error] = 'ライブ登録に失敗しました...。お手数ですが最初からやり直してください。'
            render :new
        end
  end

  def index
    @events = Event.page(params[:page]).includes(:event_performers, :event_links, :event_categories).reverse_order
  end

  def search
      @date = params[:date]
      @keyword = params[:keyword]
      @date_button = params[:date]

      #ライブ情報を指定日付で検索
      return @events = SearchDatetimeService.new(@date_button).execute if @date_button.present?

      #入力された日付もしくはキーワードで検索
      return @events = SearchKeywordService.new(params[:keyword]).execute if params[:keyword].present?
      return @events = SearchDatetimeService.new(params[:datetime]).execute if params[:datetime].present?

  end

  def show
  end

  def edit

  end

  def beachv
  end

  def update
      # エラーチェック＆DB保存→詳細画面へリダイレクト
      if @event.update(event_params)
          # イベントが編集されたら、変更履歴テーブルを更新
          @event_id = @event.id
          UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute

          redirect_to event_path(params[:id]) , notice: 'ありがとうございます！ライブ登録が完了しました！'
      else
          flash.now[:error] = 'ライブ編集に失敗しました...。お手数ですが最初からやり直してください。'
          render :edit
      end
  end

  def destroy
      @event.destroy
      redirect_to events_path
  end

private
  #ライブ情報
  def event_params
      params.require(:event)
      .permit(
          :id,
          :datetime,
          :title,
          :description,
          :tel,
          :email,
          :image,
          event_links_attributes: [
              :id,
              :event_id,
              :url],
          event_change_histories_attributes: [
              :id,
              :event_id,
              :user_id,
              :user_ip],
          event_performers_attributes: [
              :id,
              :event_id,
              :performer],
          event_categories_attributes: [
              :id,
              :event_id,
              :category]
      )
  end

  #ユーザー情報
  def user_params
      params.require(:user).permit(:id, :name, :profile_image, :uid, :email, :password)
  end

  #検索クエリ
  def search_params
      params.require(:q).permit(:title_or_description_or_event_performers)
      params.require(:keyword).permit(:title_or_description)
      params.require(:date).permit(:datetime_eq)
      params.require(:date_and_keyword).permit
  end

  def set_event
      @event = Event.find_by!(id: params[:id])
  end

  def set_current_user
      if current_user.present?
          @user = current_user
          # ログインユーザーを取得
          @user_id = current_user.id
      end
  end

  def set_remote_ip
     # ipアドレスを取得
       @remote_ip = request.remote_ip
  end
end