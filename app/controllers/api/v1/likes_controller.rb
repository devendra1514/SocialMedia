module Api::V1
  class LikesController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]

    def index
      @pagy, @users = pagy(User.joins(:likes).where(likes: { likeable_id: @parent_resource.id, likeable_type: @parent_resource.class.name }))
    end

    def create
      like = @parent_resource.likes.find_or_initialize_by(user_id: current_user.user_id)
      if like.persisted?
        like.destroy
        @message = 'Disliked'
      elsif like.save
        @message = 'Liked'
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
