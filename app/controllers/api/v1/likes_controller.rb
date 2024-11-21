module Api::V1
  class LikesController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]

    RESOURCE_CLASSES = {
      'Post' => Post,
      'Comment' => Comment,
      'Moment' => Moment
    }.freeze

    def index
      @pagy, @users = pagy(User.joins(:likes).where(likes: { likeable_id: @parent_resource.id, likeable_type: @parent_resource.class.name }))
    end

    def create
      like = @parent_resource.likes.find_or_initialize_by(user_id: current_user.user_id)
      if like.persisted?
        like.destroy
        @message = I18n.t('dislike')
      elsif like.save
        @message = I18n.t('like')
      else
        render_unprocessable_entity(like.errors)
      end
    end

    private

    def set_parent_resource
      resource_class = RESOURCE_CLASSES[params[:resource_type]]

      if resource_class.nil?
        render json: { error: I18n.t('param_missing_or_invalid') }, status: :bad_request
      else
        @parent_resource = resource_class.find_by("#{resource_class.name.underscore}_id": params[:resource_id])
        render_not_found(I18n.t("#{resource_class.name.underscore}.not_found")) unless @parent_resource.present?
      end
    end
  end
end
