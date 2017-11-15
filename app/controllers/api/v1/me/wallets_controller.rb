module Api
  module V1
    module Me
      class WalletsController < BaseController
        respond_to :json

        before_action :require_login!

        def show
          render json: wallet_response, status: 201
        end

        def update
          if @wallet.update(wallet_params)
            render json: wallet_response, status: 202
          else
            render json: @wallet.errors, status: 403
          end
        end

        private

        def wallet_response
          {
            max_limit: number_with_precision(@wallet.max_limit, precision: 2, strip_insignificant_zeros: true),
            limit:    number_with_precision(@wallet.limit, precision: 2, strip_insignificant_zeros: true),
            available_balance: number_with_precision(@wallet.available_balance, precision: 2, strip_insignificant_zeros: true)
          }
        end

        def wallet_params
          params.require(:wallet).permit(:limit)
        end
      end
    end
  end
end
