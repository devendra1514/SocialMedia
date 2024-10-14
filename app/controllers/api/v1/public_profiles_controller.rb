module Api::V1
  class PublicProfilesController < Api::AppController
    before_action :set_user

    def posts
      @pagy, @posts = pagy(@user.posts.includes([:user]))
    end

    def comments
      @pagy, @comments = pagy(@user.comments.includes([:user]))
    end

    def like_posts
      @pagy, @posts = pagy(Post.includes(likes: :user).where(likes: { user_id: @user.user_id }).includes(user: :avatar_attachment))
    end

    def like_comments
      @pagy, @comments = pagy(Comment.includes(likes: :user).where(likes: { user_id: @user.user_id }).includes(user: :avatar_attachment))
    end

    def followers
      @pagy, @users = pagy(User.includes(:followers).where(follows: { follower_id: @user.user_id }).includes([:avatar_attachment]))
    end

    def followings
      @pagy, @users = pagy(User.includes(:followings).where(follows: { followed_id: @user.user_id }).includes([:avatar_attachment]))
    end

    def groups
      @pagy, @groups = pagy(@user.created_groups.includes(:creator, :logo_attachment))
    end

    def moments
      @pagy, @moments = pagy(@user.moments.includes(:user))
    end

    private

    def set_user
      @user = User.find_by(user_id: params[:id])
      return render json: { error: 'Account not found' } unless @user.present?
    end
  end
end
