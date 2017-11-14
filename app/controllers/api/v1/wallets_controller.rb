module Api
  module V1
    class WalletsController < BaseController
      respond_to :json

      before_action :require_login!
      before_action :set_wallet

      def show
        render json: wallet_response, status: 201
      end

      private

      def set_wallet
        @wallet = current_user.wallet
      end

      def wallet_response
        { max_limit: @wallet.max_limit,
          limit:     @wallet.limit,
        }
      end
    end
  end
end
