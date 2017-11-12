require 'rails_helper'
RSpec.describe Api::V1::SessionsController, type: :request do
  describe 'POST #create' do
    context 'when users logs in' do
      before(:each) do
        @user = create(:user)
        login_params = { user: {email: @user.email, password: @user.password } }
        post api_v1_signin_path(params: login_params)
      end


      it 'receives token' do
        token = as_json(response.body)
        expect(token[:token]).not_to be_nil
      end

      it 'creates token for user' do
        token = as_json(response.body)
        expect(@user.reload.auth_token).to eq token[:token]
      end

      it 'receives status code 202' do
        expect(response).to have_http_status(202)
      end
    end

    context 'when users dont log in' do
      before(:each) do
        @user = create(:user)
        login_params = { user: {email: @user.email, password: "" } }
        post api_v1_signin_path(params: login_params)
      end

      it 'receives errors message' do
        errors = as_json(response.body)
        expect(errors[:errors]).to eq(I18n.t('devise.failure.invalid', authentication_keys: 'email'))
      end

      it 'receives status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end
end
