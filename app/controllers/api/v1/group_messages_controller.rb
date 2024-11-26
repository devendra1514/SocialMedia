module Api::V1
  class GroupMessagesController < Api::AppController
    before_action :set_group, only: %i[index create update destroy]
    before_action :set_group_message, only: %i[update destroy]
    authorize_resource except: %i[index create]

    def index
      authorize! :read_group_message, @group
      messages = @group.messages.includes(:sender)
      @pagy, @messages = pagy(messages)
    end

    def create
      authorize! :create_group_message, @group
      @group_message = @group.messages.new(group_message_params)
      if @group_message.save
      else
        render_unprocessable_entity(@group_message.errors)
      end
    end

    def update
      if @group_message.update(update_group_message_params)
      else
        render_unprocessable_entity(@group_message.errors)
      end
    end

    def destroy
      @group_message.destroy
    end

    private

    def group_message_params
      params.permit(:content).merge(sender_id: current_user.user_id)
    end

    def update_group_message_params
      params.permit(:content)
    end

    def set_group
      @group = Group.find_by(group_id: params[:group_id])
      return render_not_found(I18n.t('group.not_found')) unless @group
    end

    def set_group_message
      @group_message = GroupMessage.find_by(group_message_id: params[:id])
      return render_not_found(I18n.t('message.not_found')) unless @group_message
    end
  end
end
