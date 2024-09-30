module Api::V1
  class FollowsController < Api::AppController
    before_action :set_following, only: %i[create]

    def create
      follow = @current_user.follows_as_follower.find_or_initialize_by(followed_id: @followed_user.user_id)
      if follow.persisted?
        follow.destroy
        render json: { message: 'Unfollow' }
      elsif follow.save
        render json: { message: 'Follow' }
      else
        render_unprocessable_entity(follow.errors)
      end
    end

    private

    def set_following
      @followed_user = User.find_by(user_id: params[:followed_id])
      render json: { error: 'Account not found' }, status: :not_found unless @followed_user
    end
  end
end
