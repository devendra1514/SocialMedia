module Api::V1
  class MomentsController < Api::AppController
    before_action :set_moment, only: %i[show update destroy]

    def index
      case params[:moment_type]
      when 'following_moments'
        @pagy, @moments = pagy(Moment.where(user: current_user.followings).includes(
          media_attachment: [blob: :variant_records],
          user: [avatar_attachment: [blob: :variant_records]]))
      else
        @all_moments = Moment.unscoped
          .left_joins(:comments, :likes)
          .includes(
            media_attachment: [blob: :variant_records],
            user: [avatar_attachment: [blob: :variant_records]])
          .joins("LEFT JOIN comments AS child_comments ON child_comments.commentable_id = comments.comment_id
            AND child_comments.commentable_type = 'Comment'")
          .select('moments.*, GREATEST(COALESCE(MAX(comments.created_at), moments.created_at), COALESCE(MAX(child_comments.created_at), moments.created_at), COALESCE(MAX(likes.created_at), moments.created_at)) AS last_interaction_time')
          .group('moments.moment_id')
        @all_moments = @all_moments.search(params[:q]).records if params[:q].present?
        @pagy, @moments = pagy(@all_moments)
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
