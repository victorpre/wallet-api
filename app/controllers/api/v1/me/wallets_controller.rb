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
          { max_limit: @wallet.max_limit,
            limit:     @wallet.limit,
            available_balance: @wallet.available_balance
          }
        end

        def wallet_params
          params.require(:wallet).permit(:limit)
        end
      end
    end
  end
end
