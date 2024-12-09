module Api::V1
  class GroupMessageChannel < ApplicationCable::Channel
    def subscribed
      @group = Group.find(params[:group_id])
      unless @group.members.include?(current_user)
        reject
        Rails.logger.error(I18n.t('not_authorised'))
      end
      stream_for "api_v1_group_#{@group.group_id}"
    rescue ActiveRecord::RecordNotFound
      Rails.logger.error(I18n.t('group.not_found'))
      reject
    end

    def create(data)
      @group_message = @group.messages.new(group_message_params(data))
      if @group_message.save
        data = ApplicationController.renderer.render(
          template: 'api/v1/group_messages/_group_message',
          locals: { group_message: @group_message }
        )
        BroadcastGroupMessageJob.new.perform(@group.group_id, data)
      else
        Rails.logger.error(@group_message.errors.full_messages)
        reject
      end
    end

    private

      def group_message_params(data)
        data.slice(*[:content].map(&:to_s)).merge(sender_id: current_user.user_id)
      end
  end
end
