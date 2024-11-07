module Api::V1
  class ProfilesController < Api::AppController
    before_action :set_user

    def my_posts
      @pagy, @posts = pagy(@user.posts.includes(:user, media_attachment: [blob: [preview_image_attachment: :blob]]))
    end

    def my_comments
      @pagy, @comments = pagy(@user.comments.includes(:user))
    end

    def my_like_posts
      @pagy, @posts = pagy(Post.joins(:likes).where(likes: { user_id: @user.id }).includes(:user, user: :avatar_attachment))
    end

    def my_like_comments
      @pagy, @comments = pagy(Comment.joins(:likes).where(likes: { user_id: @user.id }).includes(:user, user: :avatar_attachment))
    end

    def my_followers
      @pagy, @users = pagy(@user.followers.includes(:avatar_attachment))
    end

    def my_followings
      @pagy, @users = pagy(@user.followings.includes(:avatar_attachment))
    end

    def my_groups
      @pagy, @groups = pagy(@user.created_groups.includes(:creator, :logo_attachment))
    end

    def my_moments
      @pagy, @moments = pagy(@user.moments.includes(:user, [media_attachment: [blob: [preview_image_attachment: :blob]]]))
    end

    private

    def set_user
      @user = current_user
    end
  end
end
