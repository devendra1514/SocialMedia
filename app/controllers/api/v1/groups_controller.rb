module Api::V1
  class GroupsController < Api::AppController
    before_action :set_group, only: %i[show update destroy]

    def index
      @pagy, @groups = pagy(current_user.groups.includes([:logo_attachment, creator: :avatar_attachment]))
    end

    def create
      @group = current_user.created_groups.new(create_group_params)
      if @group.save
      else
        render_unprocessable_entity(@group.errors)
      end
    end

    def show; end

    def update
      if @group.update(update_group_params)
      else
        render_unprocessable_entity(@group.errors)
      end
    end

    def destroy
      @group.destroy
    end

    private

    def create_group_params
      params.permit(:name, :logo)
    end

    def update_group_params
      params.permit(:name, :username, :logo)
    end

    def set_group
      @group = Group.find_by(group_id: params[:id])
      return render_not_found('Group not found') unless @group.present?
      authorize! action_name.to_sym, @group
    end
  end
end
