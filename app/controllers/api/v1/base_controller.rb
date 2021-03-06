module Api
  module V1
    class  BaseController < ApplicationController
      include ActionView::Helpers::NumberHelper

      before_action :set_wallet, if: -> { current_user.present? }

      def require_login!
        return true if authenticate_token
        render json: { errors: I18n.t('devise.failure.unauthorized') }, status: 401
      end

      def current_user
        @_current_user ||= authenticate_token
      end

      private

      def authenticate_token
        authenticate_with_http_token do |token, options|
          return false unless token.present?
          User.find_by(auth_token: token)
        end
      end

      def set_wallet
        @wallet = current_user.wallet
      end
    end
  end
end
