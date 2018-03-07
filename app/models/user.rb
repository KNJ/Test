class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # 1Userにつき何個もライブ情報を登録できる
    has_many :events

  # 1Userにつき何個もイイねできる
    has_many :participates, dependent: :destroy

  # 1Userにつき何個も検討中に入れられる
    has_many :pendings, dependent: :destroy

  # プロフィール画像の利用
   attachment :profile_image

  # Twitter認証の場合はemailを要求しない
  # def email_required?
  #  (authentications.empty? || !email.blank?) && super
  # end

  # Twitterログイン認証
  def self.find_for_oauth(auth, signed_in_resource=nil)
    user = User.where(uid: auth.uid, provider: auth.provider).first

    unless user
      user = User.create(
       uid:      auth.uid,
       provider: auth.provider,
       email:    User.dummy_email(auth),
       password: Devise.friendly_token[0, 20]
      )
    end
    user.skip_confirmation!
    # email仮をデータベースに保存するため、validationを一時的に無効化。
    user.save(validate: false)
    user
  end

  # 通常サインアップ時のuid用、Twitter OAuth認証時のemail用にuuidな文字列を生成
  # def self.create_unique_string
  #   SecureRandom.uuid
  # end

  # twitterではemailを取得できないので、適当に一意のemailを生成
  private
  def self.dummy_email(auth)
    "#{auth.uid}-#{auth.provider}@example.com"
   end
end