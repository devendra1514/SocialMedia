module Api::V1
  class MomentsController < Api::AppController
    before_action :set_moment, only: %i[show update destroy]

    def index
      case params[:moment_type]
      when 'following_moments'
        posts = Moment.where(user: current_user.followings)
                  .includes(
                    media_attachment: [blob: :variant_records],
                    user: [avatar_attachment: [blob: :variant_records]]
                  )

        @pagy, @moments = pagy(posts)
      else
        posts = Moment.unscoped
                  .includes(
                    media_attachment: [blob: [preview_image_attachment: :blob]],
                    user: [avatar_attachment: :blob]
                  )
        posts = posts.search(params[:q]).records if params[:q].present?

        @pagy, @moments = pagy(posts)
      end
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
      return render_not_found('Moment not found') unless @moment.present?
      authorize! action_name.to_sym, @moment
    end
  end
end
