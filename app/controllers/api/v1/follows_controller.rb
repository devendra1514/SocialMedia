module Api::V1
  class FollowsController < Api::AppController
    before_action :set_following, only: %i[create]

    def create
      follow = @current_user.follows_as_follower.find_or_initialize_by(followed_id: @followed_user.user_id)
      if follow.persisted?
        follow.destroy
        render json: { message: I18n.t('unfollow') }
      elsif follow.save
        render json: { message: I18n.t('follow') }
      else
        render_unprocessable_entity(follow.errors)
      end
    end

    private

    def set_following
      @followed_user = User.find_by(user_id: params[:followed_id])
      render_not_found(I18n.t('user.not_found')) unless @followed_user
    end
  end
end
