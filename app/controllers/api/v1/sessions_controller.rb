module Api
  module V1
    class  SessionsController < BaseController
      respond_to :json
      before_action :require_login!, only: [:destroy]

      def create
        @user = User.find_by_email(sign_in_params[:email])

        if @user&.valid_password?(sign_in_params[:password])
          return render json: { token: @user.auth_token }, status: 202
        end
        invalid_login_attempt
      end

      def destroy
        @user = current_user
        @user.expire_auth_token!
        render json: { notice: I18n.t('devise.sessions.signed_out')  }, status: 200
      end

      private

      def sign_in_params
        params.require(:user).permit(:email, :password)
      end

      def invalid_login_attempt
        render json: { errors: I18n.t('devise.failure.invalid', authentication_keys: 'email') }, status: 401
      end
    end
  end
end
