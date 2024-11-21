module Api::V1
  class ViewsController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]

    RESOURCE_CLASSES = {
      'Moment' => Moment
    }.freeze

    def index
      @pagy, @users = pagy(User.joins(:views).where(views: { viewable_id: @parent_resource.id, viewable_type: @parent_resource.class.name }))
    end

    def create
      view = @parent_resource.views.find_or_initialize_by(user_id: current_user.user_id)
      if view.persisted?
        @message = I18n.t('already_viewed')
      elsif view.save
        @message = I18n.t('viewed')
      else
        render_unprocessable_entity(view.errors)
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
