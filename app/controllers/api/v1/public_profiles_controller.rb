module Api::V1
  class PublicProfilesController < Api::AppController
    before_action :set_user

    def posts
      pagy, posts = pagy(@user.posts)
      render json: PostSerializer.new(posts, params: { post_author: @user, current_user: current_user })
    end

    def comments
      pagy, comments = pagy(@user.comments)
      render json: CommentSerializer.new(comments, params: { comment_author: @user, current_user: current_user })
    end

    def like_posts
      pagy, posts = pagy(Post.includes(likes: :user).where(likes: { user_id: @user.user_id }).includes(:user))
      render json: PostSerializer.new(posts, params: { current_user: @user, is_current_user_like_post: true })
    end

    def like_comments
      pagy, comments = pagy(Comment.includes(likes: :user).where(likes: { user_id: @user.user_id }).includes(:user))
      render json: CommentSerializer.new(comments, params: { current_user: @user, is_current_user_like_comment: true })
    end

    def followers
      users = User.includes(:followers).where(follows: { follower_id: @user.user_id })
      render json: UserSerializer.new(users)
    end

    def followings
      users = User.includes(:followings).where(follows: { followed_id: @user.user_id })
      render json: UserSerializer.new(users)
    end

    private

    def set_user
      @user = User.find_by(user_id: params[:id])
      return render json: { error: 'Account not found' } unless @user.present?
    end
  end
end
