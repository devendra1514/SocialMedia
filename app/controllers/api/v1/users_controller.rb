module Api::V1
  class UsersController < Api::AppController
    skip_before_action :validate_token!, only: %i[create]

    def create
      user = User.new(user_create_params)
      if user.save
        render json: UserSerializer.new(user), status: :created
      else
        render json: { errors: user.errors }, status: :unprocessable_entity
      end
    end

    def show
      render json: UserSerializer.new(current_user)
    end

    def update
      if current_user.update(user_update_params)
        render json: UserSerializer.new(current_user)
      else
        render json: { error: current_user.error }, status: :unprocessable_entity
      end
    end

    def destroy
      current_user.destroy
      render json: { message: "Account deleted successfully" }
    end

    private

    def user_create_params
      params.permit(:name, :full_phone_number, :username, :password, :password_confirmation).merge(role_id: Role.find_by(role_id: 'user').role_id)
    end

    def user_update_params
      params.permit(:name, :password, :password_confirmation)
    end
  end
end
