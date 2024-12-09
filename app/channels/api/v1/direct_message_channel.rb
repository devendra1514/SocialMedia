module Api::V1
  class DirectMessageChannel < ApplicationCable::Channel
    def subscribed
      @sender = User.find(params[:user_id])
      stream_for "api_v1_user_#{@sender.user_id}"
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error(I18n.t('user.not_found'))
      reject
    end

    def create(data)
      @direct_message = DirectMessage.new(direct_message_params(data))
      if @direct_message.save
        BroadcastDirectMessageJob.new.perform(current_user.user_id, data)
      else
        Rails.logger.error(@direct_message.errors.full_messages)
        reject
      end
    end

    private
      private

      def direct_message_params(data)
        data.slice(*[:content].map(&:to_s)).merge(sender_id: current_user.user_id).merge(recipient_id: @sender.user_id)
      end
  end
end
