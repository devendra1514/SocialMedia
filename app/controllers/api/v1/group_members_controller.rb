module Api::V1
  class GroupMembersController < Api::AppController
    before_action :set_group, only: %i[index create destroy]
    before_action :set_group_member, only: %i[destroy]

    def index
      @pagy, @members = pagy(@group.members.includes([:avatar_attachment]))
    end

    def create
      group_member = @group.group_memberships.new(group_member_params)
      authorize! action_name.to_sym, group_member
      if group_member.save
        render json: { message: I18n.t('added') }
      else
        render_unprocessable_entity(group_member.errors)
      end
    end

    def destroy
      authorize! action_name.to_sym, @group_member
      @group_member.destroy
      render json: { message: I18n.t('removed') }
    end

    private

    def group_member_params
      params.permit(:user_id)
    end

    def set_group
      @group = Group.find_by(group_id: params[:group_id])
      render_not_found(I18n.t('group.not_found')) unless @group
    end

    def set_group_member
      @group_member = @group.group_memberships.find_by(user_id: params[:id])
      render_not_found(I18n.t('member.not_found')) unless @group_member
    end
  end
end
