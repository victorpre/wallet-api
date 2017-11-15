module Api
  module V1
    module Me
      class PurchasesController < BaseController
        respond_to :json
        before_action :require_login!

        def create
          purchase = purchase_with_service
          if purchase
            render json: purchase_reponse, status: 201
          else
            render json: @wallet.errors, status: 403
          end
        end

        private

        def purchase_reponse
          { paid: number_with_precision(purchase_params[:amount], precision: 2, strip_insignificant_zeros: true),
            cards_used: @purchase_result[:cards].pluck(:id)
          }
        end

        def purchase_params
          params.require(:purchase).permit(:amount)
        end

        def purchase_with_service
          credit_card_service = PaymentService.new(@wallet, purchase_params)
          @purchase_result = credit_card_service.make_purchase
          @wallet = @purchase_result[:wallet]
          @wallet.errors.empty?
        end
      end
    end
  end
end

