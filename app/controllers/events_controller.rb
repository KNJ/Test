class EventsController < ApplicationController
  before_action :set_event, only: [:show, :update, :edit, :destroy]
  before_action :set_current_user, only: [:index, :show, :update, :edit, :destroy, :schedule]
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

    # 出演者とカテゴリを改行コードで分けるために変数に入れる
      @event_performers = event_params[:event_performers_attributes]

    # 出演者とカテゴリは別途作成するので空欄にする
      @event.event_performers.clear

    # DB保存→詳細画面へリダイレクト
    if @event.save
        # イベントが登録されたら、変更履歴テーブルを更新
        UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute

        # 出演者を1行ごとのレコードに分ける
        EventPerformersSplitService.new(@event_performers,@event.id).execute

        # カテゴリを1行ごとのレコードに分ける
        # EventPerformersSplitService.new(@event_performers,@event.id).execute

        redirect_to event_path(@event.id), notice: 'ありがとうございます！ライブ登録が完了しました！'
    else
        flash.now[:error] = 'ライブ登録に失敗しました...。お手数ですが最初からやり直してください。'
        render :new
    end
  end

  def index

    return @results = SearchDatetimeService.new('today',DateTime.now).execute

  end

  def search

    # 日付検索
    return @results = SearchDatetimeService.new(params[:date],params[:datetime]).execute if params[:date].present?
    
    # キーワード検索
    return @results = SearchKeywordService.new(params[:keyword]).execute if params[:keyword].present?
   
    # 出演者検索
    return @results = SearchEventPerformerService.new(params[:performer]).execute if params[:performer].present?

    # 会場検索
    return @results = SearchEventPlaceService.new(params[:place]).execute if params[:place].present?

    # カテゴリ検索
    return @results = SearchEventCategoryService.new(params[:category]).execute if params[:category].present?

  end

  def show
  end

  def edit
    # 出演者を取得する
    @event_performers_list = EventPerformer.where(event_id: @event.id).pluck(:performer)
    @event_performers = TextareaConcatService.new(@event_performers_list).execute

    # カテゴリを取得する
    @event_categories_list = EventCategory.where(event_id: @event.id).pluck(:category)
    @event_categories = TextareaConcatService.new(@event_categories).execute

  end

  def update
    @event_performers = event_params[:event_performers_attributes]

    # エラーチェック＆DB保存→詳細画面へリダイレクト
    if @event.update(event_params)
        # イベントが編集されたら、変更履歴テーブルを更新
        @event_id = @event.id
        UpdateEventChangeHistoryService.new(@event.id,@remote_ip,@user_id).execute
      
        # Event_performersを1行ごとのレコードに分ける
        EventPerformersSplitService.new(@event_performers,@event.id).execute
        
        redirect_to event_path(id: @event.id, performer: @event_performers) , notice: 'ありがとうございます！ライブ登録が完了しました！'
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
      @event_participates = Event.default.where(participates: { user_id: current_user.id } )
      @event_pendings = Event.default.where(pendings: { user_id: current_user.id } )
      
      # 自分の投稿を表示する
      @events = EventChangeHistory.where(user_id: @user.id)
      @events_posted = Event.default.where(id: @events.pluck(:event_id).uniq)

      # フォローしてる芸人のIDを取得する
      # 芸人のIDを取得する
      @geinins = Geinin.default.where(followings: {user_id: @user.id})
      @geinins_names = @geinins.pluck(:name).uniq
      @event_followings = Event.default.where(event_performers: { performer: @geinins_names } )   
      @results = @event_participates, @event_pendings, @event_followings,@events_posted
    else
      @results = nil, nil, nil
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