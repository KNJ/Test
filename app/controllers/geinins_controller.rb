class GeininsController < ApplicationController
  before_action :set_geinin, only: %i(show update edit destroy)
  before_action :set_current_user, only: %i(index show update edit destroy schedule following)
  before_action :set_remote_ip, only: %i(create update)

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
      @geinin_tags = geinin_params[:geinin_tags_attributes]
      binding.pry
      @geinin_member_tags = geinin_params[:geinin_members_attributes]

    # Performerは別途作成するので空欄にする
      @geinin.geinin_tags.clear
      @geinin.geinin_member_tags.clear

    # DB保存→詳細画面へリダイレクト
    if @geinin.save
        # Event_performersを1行ごとのレコードに分ける
        GeininTagsSplitService.new(@geinin_tags,@geinin_member_tags,@geinin.id).execute

        redirect_to geinin_path(@geinin.id), notice: 'ありがとうございます！芸人wiki登録が完了しました！'    
    else
        flash.now[:error] = '芸人wiki登録に失敗しました...。お手数ですが最初からやり直してください。'
        render :new
    end
  end

  def index
    @a_indexes = ["あ%","い%","う%","え%","お%"]
    @ka_indexes = ["か%","き%","く%","け%","こ%"]
    @sa_indexes = ["さ%","し%","す%","せ%","そ%"]
    @ta_indexes = ["た%","ち%","つ%","て%","と%"]
    @na_indexes = ["な%","に%","ぬ%","ね%","の%"]
    @ha_indexes = ["は%","ひ%","ふ%","へ%","ほ%"]
    @ma_indexes = ["ま%","み%","む%","め%","も%"]
    @ya_indexes = ["や%","ゆ%","よ%","",""]
    @ra_indexes = ["ら%","り%","る%","れ%","ろ%"]
    @wa_indexes = ["わ%","を%","ん%","",""]

    @indexes = [@a_indexes,@ka_indexes,@sa_indexes,@ta_indexes,@na_indexes,@ha_indexes,@ma_indexes,@ya_indexes,@ra_indexes,@wa_indexes]
    
    @counts = []

    @indexes.each do | index |
        @results = Geinin.index_search(index[0],index[1],index[2],index[3],index[4]).count
        @counts.push(@results)
    end
    
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
    return @results = SearchGeininByKeywordService.new(params[:keyword]).execute if params[:keyword].present?

    # あいうえおで検索
    if params[:index].present?
        results = SearchGeininByIndexService.new(params[:index]).execute
        @geinins = results[0]
        @a = results[1]
        @i = results[2]
        @u = results[3]
        @e = results[4]
        @o = results[5]
        @geinin_tags = GeininTag.order("RANDOM()").limit(10)
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
                #   geinin_member_tags_attributes: [
                #       :id,
                #       :geinin_id,
                #       :geinin_member_id,
                #       :tag],
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