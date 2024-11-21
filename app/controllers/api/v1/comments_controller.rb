module Api::V1
  class CommentsController < Api::AppController
    before_action :set_parent_resource, only: %i[index create]
    before_action :set_comment, only: %i[show update destroy]

    RESOURCE_CLASSESS = {
      'Post' => Post,
      'Moment' => Moment,
      'Comment' => Comment
    }.freeze

    def index
      @pagy, @comments = pagy(@parent_resource.comments.includes(
        user: [avatar_attachment: :blob]))
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
      resource_class = RESOURCE_CLASSESS[params[:resource_type]]

      if resource_class.nil?
        render json: { error: I18n.t('param_missing_or_invalid') }, status: :bad_request
      else
        @parent_resource = resource_class.find_by("#{resource_class.name.underscore}_id": params[:resource_id])
        render_not_found(I18n.t("#{resource_class.name.underscore}.not_found")) unless @parent_resource.present?
      end
    end

    def set_comment
      @comment = Comment.find_by(comment_id: params[:id])
      return render_not_found(I18n.t('comment.not_found')) unless @comment.present?
      authorize! action_name.to_sym, @comment
    end
  end
end
