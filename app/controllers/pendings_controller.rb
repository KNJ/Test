class PendingsController < ApplicationController
    before_action :authenticate_user
    
    def create
        event = Event.find(params[:event_id])
        pending = current_user.pendings.new(event_id: event.id)
        pending.save
        @event = Event.find(params[:event_id])
        @pending = current_user.pendings.find_by(event_id: params[:event_id])
    end

    def destroy
        pending = current_user.pendings.find_by(event_id: params[:event_id])
        pending.destroy
        @event = Event.find(params[:event_id])
        @pending = current_user.pendings.find_by(event_id: params[:event_id])
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
end
