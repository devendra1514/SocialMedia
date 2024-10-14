module Api::V1
  class PostsController < Api::AppController
    before_action :set_post, only: %i[show update destroy]

    def index
      case params[:post_type]
      when 'following_posts'
        @pagy, @posts = pagy(Post.following_posts(current_user))
      else
        @all_posts = Post.unscoped.left_joins(:comments, :likes).includes([:user, user: :avatar_attachment])
              .joins("LEFT JOIN comments AS child_comments ON child_comments.commentable_id = comments.comment_id AND child_comments.commentable_type = 'Comment'")
              .select('posts.*, GREATEST(COALESCE(MAX(comments.created_at), posts.created_at), COALESCE(MAX(child_comments.created_at), posts.created_at), COALESCE(MAX(likes.created_at), posts.created_at)) AS last_interaction_time')
              .group('posts.post_id')
        @all_posts = @all_posts.search(params[:q]).records if params[:q].present?
        @pagy, @posts = pagy(@all_posts)
      end
    end

    def create
      @post = current_user.posts.new(post_params)
      if @post.save
      else
        render_unprocessable_entity(@post.errors)
      end
    end

    def show; end

    def update
      if @post.update(post_params)
      else
        render_unprocessable_entity(@post.errors)
      end
    end

    def destroy
      @post.destroy
    end

    private

    def post_params
      params.permit(:title)
    end

    def set_post
      @post = Post.find_by(post_id: params[:id])
      return render_not_found(I18n.t('post.not_found')) unless @post.present?
      authorize! action_name.to_sym, @post
    end
  end
end
