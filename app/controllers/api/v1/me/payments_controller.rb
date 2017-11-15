module Api
  module V1
    module Me
      class PaymentsController < BaseController
        respond_to :json
        before_action :require_login!
        before_action :set_credit_card

        def create
          payment = payment_with_service
          if payment
            render json: payment_response, status: 202
          else
            render json: payment_error, status: 403
          end
        end

        private

        def set_credit_card
          @card = @wallet.credit_cards.find_by(id: params[:id])
        end

        def payment_params
          params.require(:payment).permit(:amount)
        end

        def payment_with_service
          payment_service = CreditCardService.new(@wallet, payment_params)
          @card = payment_service.pay_credit_card_bill(@card)
          @card.present? && @card.errors.empty?
        end

        def payment_response
          {
            paid: number_with_precision(payment_params[:amount], precision: 2, strip_insignificant_zeros: true),
            balance: number_with_precision(@card.balance, precision: 2, strip_insignificant_zeros: true),
          }
        end

        def payment_error
          @card.nil? ? { credit_card: [I18n.t('cannot_pay_credit_card')] } : @card.errors
        end
      end
    end
  end
end

