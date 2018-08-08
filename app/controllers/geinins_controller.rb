class GeininsController < ApplicationController
  before_action :set_geinin, only: %i(show update edit destroy)
  before_action :set_current_user, only: %i(index show update edit destroy schedule following)
  before_action :set_remote_ip, only: %i(create update)
  before_action :ensure_correct_user, only: %i[destroy]

  def new
      # 芸人を登録
        @geinin = Geinin.new

      # メンバー情報を登録
        @geinin.geinin_members.build

      # タグを登録
        @geinin.geinin_tags.build

  end

  def create
    # イベント情報を取得
      @geinin = Geinin.new(geinin_params)

    # タグを改行コードで分けるために別途変数に入れる
      geinin_tags = geinin_params[:geinin_tags_attributes]
      geinin_members = geinin_params[:geinin_members_attributes]
      # geinin_member_tags = geinin_members[:geinin_member_tags_attributes]

    # 芸人タグは別途作成するので空欄にする
      @geinin.geinin_tags.clear

      # @geinin.geinin_members.each do |geinin_member| 
      #   geinin_member.geinin_member_tags.clear
      # end

    # DB保存→詳細画面へリダイレクト
    if @geinin.save
        # 芸人タグを1行ごとのレコードに分ける
        GeininTagsSplitService.new(@geinin.id,geinin_tags).execute

        # geinin_members.each do |geinin_member|
        #   GeininMemberTagsSplitService.new(geinin_member.geinin_id,geinin_member.id,geinin_member_tags).execute
        # end

        redirect_to geinin_path(@geinin.id), notice: 'ありがとうございます！芸人wiki登録が完了しました！'    
    else
        flash.now[:error] = '芸人wiki登録に失敗しました...。お手数ですが最初からやり直してください。'
        render :new
    end
  end

  def index
    results = SearchGeininByIndexService.new('a').execute

    @geinins_list = results[0]
    @indexes = results[1]
    
    # あいうえお行の最初の1文字を取得(%を抜く)
    @a = @indexes[0][0]
    @i = @indexes[1][0]
    @u = @indexes[2][0]
    @e = @indexes[3][0]
    @o = @indexes[4][0]

    @geinin_tags = GeininTag.order("RANDOM()").limit(10)
    
  end

  def show
  end

  def edit
    @geinin_tags = GeininTag.where(geinin_id: @geinin.id).pluck(:tag)
    @text_area = TextareaConcatService.new(@geinin_tags).execute

    # 芸人メンバーのIDをとる
    @geinin_members = GeininMember.where(geinin_id: @geinin_id).pluck(:id)
    @geinin_member_tags = GeininMemberTag.where(geinin_id: @geinin_id,geinin_member_id: @geinin_members)
    @text_area = TextareaConcatService.new(@geinin_tags).execute
  end

  def update
    # エラーチェック＆DB保存→詳細画面へリダイレクト
    if @geinin.update(geinin_params)
        # イベントが編集されたら、変更履歴テーブルを更新
        @geinin_id = @geinin.id
        redirect_to geinin_path(params[:id]) , notice: 'ありがとうございます！芸人wikiの編集が完了しました！'
    else
        flash.now[:error] = '芸人wikiの編集に失敗しました。お手数ですが最初からやり直してください。'
        render :edit
    end
  end

  def destroy
      @geinin.destroy
      redirect_to geinins_path
  end

  # 芸人スケジュールの表示
  def schedule
    # ユーザーがフォローしている芸人一覧を取得
    @geinins = Geinin.default.where(followings: { user_id: @user_id } )

    # ユーザーがフォローしている芸人の名前でライブ情報を検索
    @events_followings = Event.default.where(event_performers: { performer: @geinins.name } )

  end

  def search
    # キーワードで検索
    results = SearchGeininByKeywordService.new(params[:keyword]).execute if params[:keyword].present?

    # キーワードで検索
    results = SearchGeininByTagService.new(params[:tag]).execute if params[:tag].present?

    # あいうえおで検索
    if params[:index].present?
        results = SearchGeininByIndexService.new(params[:index]).execute
        @geinin_tags = GeininTag.order("RANDOM()").limit(10)
    end

    @geinins_list = results[0]
    @indexes = results[1]
    @keyword = results[2]
    end

  def ensure_correct_user
    if current_user
      @geining = Geinin.find(user_id: current_user.id)

      if current_user.id != @geinin.user_id
        flash[:notice] = I18n.t('errors.messages.no_authorization')
        redirect_to geinin_path(@geinin.id)
      end
    end
  end

  private
    #ライブ情報
    def geinin_params
        params.require(:geinin)
        .permit(
            :id,
            :name,
            :yomi,
            :agency,
            :office,
            :start_year,
            :twitter_id,
            :instagram_id,
            :youtube_url,
            :blog_url,
            geinin_tags_attributes: [
                :id,
                :geinin_id,
                :tag],
            geinin_members_attributes: [
                :id,
                :geinin_id,
                :family_name,
                :first_name,
                :family_name_yomi,
                :first_name_yomi,
                :twitter_id,
                :instagram_id,
                :blog_url,
                :_destroy,
                # geinin_member_tags_attributes: [
                #     :id,
                #     :geinin_id,
                #     :geinin_member_id,
                #     :tag],
                ],
        )
    end

    #ユーザー情報
    def user_params
        params.require(:user).permit(:id, :name, :profile_image, :uid, :email, :password)
    end

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

    def set_current_user
      if current_user.present?
          @user = current_user
          # ログインユーザーを取得
          @user_id = current_user.id
      end
    end
 
    def set_geinin
        @geinin = Geinin.find(params[:id])
    end
end