require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(id: user.id) }

  before do
    request.headers['Accept'] = 'application/json'
  end

  describe "GET #show" do
    context 'when token is present' do
      before do
        user.update(verified: true)
        request.headers['token'] = token
      end
      context 'when token is valid and user is verified' do
        it 'returns the user details' do
          get :show, params: { id: user.id }
          expect(response).to have_http_status(:ok)
        end
      end

      context 'when token is valid and user is not verified' do
        before { user.update(verified: false) }
        it 'returns an error for unverified account' do
          get :show, params: { id: user.id }
          expect(response).to have_http_status(:bad_request)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('jwt.account_not_verified'))
        end
      end

      context 'when token is invalid' do
        it 'returns an error for invalid token' do
          request.headers[:token] = 'invalid_token'
          get :show, params: { id: user.id }
          expect(response).to have_http_status(:bad_request)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('jwt.invalid_token'))
        end
      end

      context 'when token is valid but expired' do
        it 'returns an error for session expired' do
          expired_token = JsonWebToken.encode({ id: user.id }, Time.current - 1.hour)
          request.headers[:token] = expired_token
          get :show, params: { id: user.id }
          expect(response).to have_http_status(:bad_request)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('jwt.session_expired'))
        end
      end

      context 'when token is valid but account is deleted' do
        it 'returns an error for account delete' do
          user.destroy
          get :show, params: { id: user.id }
          expect(response).to have_http_status(:bad_request)
          body = JSON.parse(response.body)
          expect(body['error']).to eq(I18n.t('jwt.account_deleted'))
        end
      end
    end

    context 'when token is missing' do
      it 'returns an error for missing token' do
        request.headers['token'] = nil
        get :show, params: { id: user.id }
        expect(response).to have_http_status(:bad_request)
        body = JSON.parse(response.body)
        expect(body['error']).to eq(I18n.t('jwt.token_missing'))
      end
    end
  end
end
