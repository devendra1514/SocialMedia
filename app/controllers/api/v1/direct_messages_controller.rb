module Api::V1
  class DirectMessagesController < Api::AppController
    before_action :set_user, only: %i[index create update destroy]
    before_action :set_direct_message, only: %i[update destroy]
    authorize_resource only: %i[update destroy]

    def conversations_user_list
      users = User.where(user_id: current_user.send_messages.select(:recipient_id))
                  .or(User.where(user_id: current_user.recieved_messages.select(:sender_id)))
                  .distinct
      @pagy, @users = pagy(users.includes(:avatar_attachment))
    end

    def index
      direct_messages = DirectMessage.where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?)",current_user.user_id, @recipient.user_id, @recipient.user_id, current_user.user_id).includes([:sender])
      @pagy, @messages = pagy(direct_messages)
      @messages = @messages.reverse
    end

    def create
      @direct_message = DirectMessage.new(create_direct_message_params)
      if @direct_message.save
        data = ApplicationController.renderer.render(
          template: 'api/v1/direct_messages/_direct_message',
          locals: { direct_message: @direct_message }
        )
        BroadcastDirectMessageJob.new.perform(current_user.user_id, data)
      else
        render_unprocessable_entity(@direct_message.errors)
      end
    end

    def update
      if @direct_message.update(update_direct_message_params)
      else
        render_unprocessable_entity(@direct_message.errors)
      end
    end

    def destroy
      @direct_message.destroy
    end

    private

    def create_direct_message_params
      params.permit(:content).merge(sender_id: current_user.user_id).merge(recipient_id: @recipient.user_id)
    end

    def update_direct_message_params
      params.permit(:content)
    end

    def set_user
      @recipient = User.find_by(user_id: params[:user_id])
      return render_not_found('Recipient not found') unless @recipient
    end

    def set_direct_message
      @direct_message = DirectMessage.find_by(direct_message_id: params[:id])
      return render_not_found(I18n.t('message.not_found')) unless @direct_message
    end
  end
end
