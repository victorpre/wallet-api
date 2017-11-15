module Api
  module V1
    module Me
      class CreditCardsController < BaseController
        include ActionView::Helpers::NumberHelper
        respond_to :json

        before_action :set_credit_card, only: [:show, :destroy]
        before_action :initialize_credit_card, only: [:create]
        before_action :require_login!

        def create
          @card.update_attributes(credit_card_params)
          if @card.save
            render json: credit_card_response, status: 201
          else
            render json: @card.errors, status: 403
          end
        end

        def destroy
          if @card.present?
            @card.destroy
            head :no_content
          else
            render json: { credit_card: [I18n.t('cannot_delete_credit_card')] }, status: 403
          end
        end

        private

        def initialize_credit_card
          @card = @wallet.credit_cards.new
        end

        def set_credit_card
          @card = @wallet.credit_cards.find_by(id: params[:id])
        end

        def credit_card_params
          params.require(:credit_card).permit(:limit,
                                              :balance,
                                              :number,
                                              :card_holder,
                                              :exp_month,
                                              :exp_year,
                                              :payment_due_date,
                                              :cvv)
        end

        def credit_card_response
          { id: @card.id,
            card_holder: @card.card_holder,
            limit: number_with_precision(@card.limit, precision: 2, strip_insignificant_zeros: true),
            exp_month: @card.exp_month,
            exp_year: @card.exp_year,
            payment_due_date: @card.payment_due_date&.strftime("%Y-%m-%d"),
            number: @card.number,
            cvv: @card.cvv
          }
        end
      end
    end
  end
end
