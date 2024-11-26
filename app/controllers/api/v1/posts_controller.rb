module Api::V1
  class PostsController < Api::AppController
    before_action :set_post, only: %i[show update destroy]
    authorize_resource

    def index
      case params[:post_type]
      when 'following_posts'
        posts = Post.where(user: current_user.followings)
      else
        posts = Post.unscoped
        posts = posts.search(params[:q]).records if params[:q].present?
      end
      posts = posts.includes(
                    media_attachment: :blob,
                    user: [avatar_attachment: :blob]
                  )
      @pagy, @posts = pagy(posts)
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
      params.permit(:title, :media)
    end

    def set_post
      @post = Post.find_by(post_id: params[:id])
      return render_not_found(I18n.t('post.not_found')) unless @post.present?
    end
  end
end
