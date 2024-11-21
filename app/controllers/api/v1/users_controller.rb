module Api::V1
  class UsersController < Api::AppController
    skip_before_action :validate_token!, only: %i[create]

    def index
      if params[:q].present?
        users = User.search_with_name_or_username(params[:q])
      else
        users = User.all
      end

      @pagy, @users = pagy(users.includes(avatar_attachment: :blob))
    end

    def create
      @user = User.new(user_create_params)
      if @user.save
        @include_full_phone = true
      else
        render json: { error: @user.errors }, status: :unprocessable_entity
      end
    end

    def show
      @include_full_phone = true
      @followers_count = current_user.followers.count
      @followings_count = current_user.followings.count
    end

    def update
      if current_user.update(user_update_params)
        @include_full_phone = true
      else
        render json: { error: current_user.errors }, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.destroy
      @include_full_phone = true
    end

    private

    def user_create_params
      params.permit(:name, :full_phone_number, :username, :password, :password_confirmation, :avatar).merge(role_id: Role.find_by(name: 'user').role_id)
    end

    def user_update_params
      params.permit(:name, :username, :password, :password_confirmation, :avatar)
    end
  end
end
