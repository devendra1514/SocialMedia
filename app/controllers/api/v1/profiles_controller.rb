module Api::V1
  class ProfilesController < Api::AppController
    def my_posts
      pagy, posts = pagy(current_user.posts)
      render json: PostSerializer.new(posts, params: { post_author: current_user, current_user: current_user })
    end

    def my_comments
      pagy, comments = pagy(current_user.comments)
      render json: CommentSerializer.new(comments, params: { comment_author: current_user, current_user: current_user })
    end

    def my_like_posts
      pagy, posts = pagy(Post.includes(likes: :user).where(likes: { user_id: current_user.user_id }).includes(:user))
      render json: PostSerializer.new(posts, params: { current_user: current_user, is_current_user_like_post: true })
    end

    def my_like_comments
      pagy, comments = pagy(Comment.includes(likes: :user).where(likes: { user_id: current_user.user_id }).includes(:user))
      render json: CommentSerializer.new(comments, params: { current_user: current_user, is_current_user_like_comment: true })
    end

    def my_followers
      users = User.includes(:followers).where(follows: { follower_id: current_user.user_id })
      render json: UserSerializer.new(users)
    end

    def my_followings
      users = User.includes(:followings).where(follows: { followed_id: current_user.user_id })
      render json: UserSerializer.new(users)
    end
  end
end
