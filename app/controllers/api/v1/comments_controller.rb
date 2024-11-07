module Api::V1
  class CommentsController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]
    before_action :set_comment, only: %i[show update destroy]

    def index
      @pagy, @comments = pagy(@parent_resource.comments.includes(
        user: [avatar_attachment: [blob: :variant_records]]))
    end

    def create
      @comment = @parent_resource.comments.new(comment_params)
      if @comment.save
      else
        render_unprocessable_entity(@comment.errors)
      end
    end

    def update
      if @comment.update(comment_params)
      else
        render_unprocessable_entity(@comment.errors)
      end
    end

    def show; end

    def destroy
      @comment.destroy
    end

    private

    def comment_params
      params.permit(:title).merge(user_id: current_user.user_id)
    end

    def set_parent_resource
      case params[:resource_type]
      when 'Post'
        @parent_resource = Post.find_by(post_id: params[:resource_id])
        render_not_found(I18n.t('post.not_found')) unless @parent_resource.present?
      when 'Comment'
        @parent_resource = Comment.find_by(comment_id: params[:resource_id])
        render_not_found(I18n.t('comment.not_found')) unless @parent_resource.present?
      else
        render json: { error: 'params is missing or invalid' }, status: :bad_request
      end
    end

    def set_comment
      @comment = Comment.find_by(comment_id: params[:id])
      return render_not_found(I18n.t('comment.not_found')) unless @comment.present?
      authorize! action_name.to_sym, @comment
    end
  end
end
