module Api::V1
  class PostsController < Api::AppController
    include PostsConcern
    authorize_resource
    before_action :set_post, only: %i[show update destroy]

    def index
      case params[:post_type]
      when 'following_posts'
        pagy, posts =  pagy(Post.following_posts(current_user))
      else
        pagy, posts = pagy(Post.left_joins(:comments, :likes).includes([:user])
              .joins("LEFT JOIN comments AS child_comments ON child_comments.commentable_id = comments.comment_id AND child_comments.commentable_type = 'Comment'")
              .select('posts.*, GREATEST(COALESCE(MAX(comments.created_at), posts.created_at), COALESCE(MAX(child_comments.created_at), posts.created_at), COALESCE(MAX(likes.created_at), posts.created_at)) AS last_interaction_time')
              .group('posts.post_id'))
      end
      render json: PostSerializer.new(posts, params: { current_user: current_user }, meta: { pagination: pagy })
    end

    def create
      post = current_user.posts.new(post_params)
      if post.save
        render json: PostSerializer.new(post), status: :created
      else
        render_unprocessable_entity(post.errors)
      end
    end

    def show
      render json: PostSerializer.new(@post)
    end

    def update
      if @post.update(post_params)
        render json: PostSerializer.new(@post)
      else
        render_unprocessable_entity(@post.errors)
      end
    end

    def destroy
      @post.destroy
      render json: PostSerializer.new(@post)
    rescue => e
      render json: { error: e, message: e.message }, status: :internal_server_error
    end

    private

    def post_params
      params.permit(:title)
    end

    def set_post
      @post = Post.find_by(post_id: params[:id])
      render_not_found('Post not found') unless @post.present?
    end
  end
end
