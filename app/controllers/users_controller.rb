class UsersController < ApplicationController
	def new
		@user = User.new
	end
	def create
		@user = User.new(user_params)
		@user.save
	end
    def edit
        @user = User.find(params[:id])
    end
	def update
	    @user = User.find(params[:id])
	    @user.update(user_params)
	    redirect_to user_path(@user.id)
	end
	def show
		@user = current_user
		
		# 自分の投稿を表示する
		@events_user = EventChangeHistory.where(user_id: @user.id)
		@events = Event.default.where(id: @events_user.pluck(:event_id).uniq)

	end

	def profile
        @user = current_user
        redirect_to user_path(@user.uid)
	end

	private
	def user_params
	    params.require(:user).permit(:id, :name, :profile_image, :uid, :email, :password)
	end
end