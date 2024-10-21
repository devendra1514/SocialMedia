module Api::V1
  class ViewsController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]

    def index
      @pagy, @users = pagy(User.joins(:views).where(views: { viewable_id: @parent_resource.id, viewable_type: @parent_resource.class.name }))
    end

    def create
      view = @parent_resource.views.find_or_initialize_by(user_id: current_user.user_id)
      if view.persisted?
        render json: { message: 'Already Viewed' }
      elsif view.save
        render json: { message: 'Viewed' }
      else
        render_unprocessable_entity(view.errors)
      end
    end

    private

    def set_parent_resource
      case params[:resource_type]
      when 'Moment'
        @parent_resource = Moment.find_by(moment_id: params[:resource_id])
        render_not_found('Moment not found') unless @parent_resource.present?
      else
        render json: { error: 'params is missing or invalid' }, status: :bad_request
      end
    end
  end
end
