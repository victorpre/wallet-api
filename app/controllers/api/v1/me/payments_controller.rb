module Api
  module V1
    module Me
      class PaymentsController < BaseController
        respond_to :json
        before_action :require_login!
        before_action :set_credit_card

        def create
          card_with_payment = pay_with_service
          if card_with_payment.errors.empty?
            render json: payment_response, status: 202
          else
            render json: card_with_payment.errors, status: 403
          end
        end

        private

        def set_credit_card
          @card = @wallet.credit_cards.find_by(id: params[:id])
          if @card.nil?
            render json: { credit_card: [I18n.t('cannot_pay_credit_card')] }, status: 403
          end
        end

        def payment_params
          params.require(:payment).permit(:amount)
        end

        def pay_with_service
          payment_service = PaymentService.new(@card, payment_params)
          payment_service.make_payment
        end

        def payment_response
          {
            paid: number_with_precision(payment_params[:amount], precision: 2, strip_insignificant_zeros: true),
            balance: number_with_precision(@card.balance, precision: 2, strip_insignificant_zeros: true),
          }
        end
      end
    end
  end
end

