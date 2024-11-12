module Api::V1
  class PublicProfilesController < Api::AppController
    before_action :set_user

    def show
      @followers_count = @user.followers.count
      @followings_count = @user.followings.count
      @followed = @user.followers.exists?(user_id: current_user.user_id)
    end

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
      @pagy, @users = pagy(@user.followers)
    end

    def followings
      @pagy, @users = pagy(@user.followings)
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
      return render json: { error: I18n.t('user.not_found') } unless @user.present?
    end
  end
end
