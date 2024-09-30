module Api
  class AppController < ApplicationController
    protect_from_forgery unless: -> { request.format.json? }

    rescue_from CanCan::AccessDenied do |e|
       render json: { error: e.message }, status: :unauthorized
     end

    include Pagy::Backend
    include JsonWebTokenValidation

    helper_method :current_user

    def set_user
      full_phone_number = Phonelib.parse(params[:full_phone_number]).full_e164
      @user = User.find_by(full_phone_number: full_phone_number)
      render json: { error: 'Account not found' }, status: :not_found unless @user.present?
    end

    def render_not_found(msg)
      render json: { error: msg }, status: :not_found
    end

    def render_unprocessable_entity(error)
      render json: { error: error }, status: :unprocessable_entity
    end
  end
end