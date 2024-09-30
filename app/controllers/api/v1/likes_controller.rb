module Api::V1
  class LikesController < Api::AppController
    authorize_resource
    before_action :set_parent_resource, only: %i[create]

    def create
      like = @parent_resource.likes.find_or_initialize_by(user_id: current_user.user_id)
      if like.persisted?
        like.destroy
        render json: { message: 'Unliked' }
      elsif like.save
        render json: { message: 'Liked' }
      else
        render_unprocessable_entity(like.errors)
      end
    end

    private

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
  end
end
