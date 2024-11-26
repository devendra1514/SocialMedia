module Api::V1
  class MomentsController < Api::AppController
    before_action :set_moment, only: %i[show update destroy]
    authorize_resource

    def index
      case params[:moment_type]
      when 'following_moments'
        moments = Moment.where(user: current_user.followings)
      else
        moments = Moment.unscoped
        moments = moments.search(params[:q]).records if params[:q].present?
      end
      momets = moments.includes(
                    media_attachment: :blob,
                    user: [avatar_attachment: :blob]
                  )
      @pagy, @moments = pagy(moments)
    end

    def create
      @moment = current_user.moments.new(moment_params)
      if @moment.save
      else
        render_unprocessable_entity(@moment.errors)
      end
    end

    def show; end

    def update
      if @moment.update(moment_params)
      else
        render_unprocessable_entity(@moment.errors)
      end
    end

    def destroy
      @moment.destroy
    end

    private

    def moment_params
      params.permit(:title, :media)
    end

    def set_moment
      @moment = Moment.find_by(moment_id: params[:id])
      return render_not_found(I18n.t('moment.not_found')) unless @moment.present?
    end
  end
end
