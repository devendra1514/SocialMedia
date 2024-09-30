module Api::V1
  class CommentsController < Api::AppController
    authorize_resource
    skip_before_action :validate_token!, only: %i[index]
    before_action :set_parent_resource, only: %i[index create]
    before_action :set_comment, only: %i[show update destroy]

    def index
      pagy, comments = pagy(@parent_resource.comments.includes([:user]))
      render json: CommentSerializer.new(comments)
    end

    def create
      comment = @parent_resource.comments.new(comment_params)
      if comment.save
        render json: CommentSerializer.new(comment), status: :created
      else
        render_unprocessable_entity(comment.errors)
      end
    end

    def update
      if @comment.update(comment_params)
        render json: CommentSerializer.new(@comment)
      else
        render_unprocessable_entity(@comment.errors)
      end
    end

    def show
      render json: CommentSerializer.new(@comment)
    end

    def destroy
      @comment.destroy
      render json: CommentSerializer.new(@comment)
    rescue => e
      render json: { error: e, message: e.message }, status: :internal_server_error
    end

    private

    def comment_params
      params.permit(:title).merge(user_id: current_user.user_id)
    end

    def set_parent_resource
      case params[:resource_type]
      when 'Post'
        @parent_resource = Post.find_by(post_id: params[:resource_id])
        render_not_found('Post not found') unless @parent_resource.present?
      when 'Comment'
        @parent_resource = Comment.find_by(comment_id: params[:resource_id])
        render_not_found('Comment not found') unless @parent_resource.present?
      else
        render json: { error: 'params is missing or invalid' }, status: :bad_request
      end
    end

    def set_comment
      @comment = Comment.find_by(comment_id: params[:id])
      render_not_found('Comment not found') unless @comment.present?
    end
  end
end
