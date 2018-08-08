class EventsController < ApplicationController
  before_action :set_event, only: %i[show update edit destroy]
  before_action :set_current_user, only: %i[index show update edit destroy schedule]
  before_action :set_remote_ip, only: %i[create update]
  before_action :ensure_correct_user, only: %i[destroy]

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

    # ライブ会場の自由入力欄が入力されていたら、自由入力欄の値を優先して保存する
      if @event.place_free_entry.present?
        @event.place = @event.place_free_entry
      end

    # 出演者とカテゴリを改行コードで分けるために変数に入れる
      @event_performers = event_params[:event_performers_attributes]

    # 出演者とカテゴリは別途作成するので空欄にする
      @event.event_performers.clear

    # ログインしてたらユーザーIDを保存
      if current_user
        @event.user_id = current_user.id
      end

    # DB保存→詳細画面へリダイレクト
    if @event.save
        # イベントが登録されたら、変更履歴テーブルを更新
        UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute

        # 出演者を1行ごとのレコードに分ける
        EventPerformersSplitService.new(@event_performers,@event.id).execute

        # カテゴリを1行ごとのレコードに分ける
        # EventPerformersSplitService.new(@event_performers,@event.id).execute

        redirect_to event_path(@event.id), notice: 'ありがとうございます！ライブの登録が完了しました！'
    else
        flash.now[:error] = 'ライブ登録に失敗しました...。お手数ですが最初からやり直してください。'
        render :new
    end
  end

  def index

    results = SearchDatetimeService.new('today',Time.zone.now).execute
    # tomorrow_results = SearchDatetimeService.new('tomorrow',DateTime.now + 1.day).execute
    # next_sat_results = SearchDatetimeService.new('next_sat',DateTime.now).execute
    # next_sun_results = SearchDatetimeService.new('next_sun',DateTime.now).execute

    @events = results[0]
    @datetime = results[1]
    # @counts = [results[4],tomorrow_results[4],next_sat_results[4],next_sun_results[4]]

  end

  def search

    # 日付検索
    results = SearchDatetimeService.new(params[:date],params[:datetime]).execute if params[:date].present?
    
    # キーワード検索
    results = SearchKeywordService.new(params[:keyword]).execute if params[:keyword].present?
   
    # 出演者検索
    results = SearchEventPerformerService.new(params[:performer]).execute if params[:performer].present?

    # 会場検索
    results = SearchEventPlaceService.new(params[:place]).execute if params[:place].present?

    # カテゴリ検索
    results = SearchEventCategoryService.new(params[:category]).execute if params[:category].present?

    @events = results[0]
    @datetime = results[1]
    @keyword = results[2]
    @geinin = results[3]

  end

  def show
  end

  def edit
    # 出演者を取得する
    event_performers_list = @event.event_performers.pluck(:performer)
    @event_performers = TextareaConcatService.new(event_performers_list).execute

    # カテゴリを取得する
    # event_categories_list = EventCategory.where(event_id: @event.id).pluck(:category)
    # @event_categories = TextareaConcatService.new(@event_categories).execute

  end

  def update
    @event_performers = event_params[:event_performers_attributes]

    # ライブ会場の自由入力欄が入力されていたら、自由入力欄の値を優先して保存する
      if @event.place_free_entry
        @event.place = @event.place_free_entry
      end

    # エラーチェック＆DB保存→詳細画面へリダイレクト
    if @event.update(event_params)
        # イベントが編集されたら、変更履歴テーブルを更新
        @event_id = @event.id
        UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute
      
        # Event_performersを1行ごとのレコードに分ける
        EventPerformersSplitService.new(@event_performers,@event.id).execute
        
        redirect_to event_path(id: @event.id, performer: @event_performers) , notice: 'ありがとうございます！ライブの編集が完了しました！'
    else
        flash.now[:error] = 'ライブ編集に失敗しました...。お手数ですが最初からやり直してください。'
        render :edit
    end
  end

  def destroy
      @event.destroy
      redirect_to events_path
  end

  # スケジュールの表示
  def schedule
    if current_user.present?

      @events_participates = Event.default.where(participates: { user_id: current_user.id } )
      @events_pendings = Event.default.where(pendings: { user_id: current_user.id } )
      @events_followings = GetFollowingEventsService.new(current_user).execute

    end
   end

  def ensure_correct_user
    if current_user.id != @event.user_id
      flash[:notice] = I18n.t('errors.messages.no_authorization')
      redirect_to event_path(@event.id)
    end
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
          :place,
          :place_free_entry,
          :general_sale,
          :presale_start,
          :presale_end,
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

  def set_event
      @event = Event.find_by!(id: params[:id])
  end

  # def set_current_user
  #   if current_user.present?
  #       @user = current_user
  #       # ログインユーザーを取得
  #       @user_id = current_user.id
  #   end
  # end

  def set_remote_ip
     # ipアドレスを取得
       @remote_ip = request.remote_ip
  end
end