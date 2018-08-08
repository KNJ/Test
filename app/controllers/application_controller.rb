class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_user
  before_action :configure_permitted_parameters, if: :devise_controller?
  helper_method :current_user, :logged_in?

  # ランディングページの表示
  def lp
    if current_user.present?
      redirect_to events_url
    else
      render '/lp'
    end
  end

  # rescue_from ActionView::MissingTemplate, with: :lp

  # 当サイトについての表示
  def about
	  render '/about'
  end

  # プライバシーポリシーの表示
  def privacy
	  render '/privacy'
  end

  # 利用規約の表示
  def terms
	  render '/terms'
  end

  # 通知ページの表示
  def notification
    render '/notification'
  end

  # 初回ログイン時のみガイドページを表示
  def register
    #　ユーザーがフォローしている芸人一覧を取得
    @geinins = Geinin.default.where(followings: { user_id: current_user.id } )   
    render '/register'
  end

  def set_current_user
    return unless session[:user_id]
    @current_user = User.find_by(id: session[:user_id])
    #@current_user ||= User.find(session[:user_id])
  end

  def logged_in?
    !!session[:user_id]
  end

  # def authenticate
  #   return if logged_in?
  #   redirect_to root_path, alert: 'ログインしてください'
  # end

  def set_remote_ip
     # ipアドレスを取得
       @remote_ip = request.remote_ip
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
  #def configure_permitted_parameters
  #  devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  #end
  def after_sign_in_path_for(resource)
    request.env['omniauth.origin'] || geinins_following_url(resource) || root_path
  end

end