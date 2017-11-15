require 'rails_helper'

RSpec.describe Api::V1::Me::PaymentsController, type: :request do
  describe 'POST #pay' do
    before do
      @user = create :user
      @credit_card = create :credit_card, limit: 4000, balance: 2000, wallet: @user.wallet
      @not_my_card = create :credit_card
    end

    context 'when card is paid succesfully' do
      subject { post create_payment_api_v1_me_wallet_cards_path(@credit_card.id, payment_attributes), headers: valid_headers }
      let(:payment_attributes) { { payment: { amount: 100 } } }
      let(:expected_response) { { paid: '100',
                                  balance: (2000-100).to_s,
      } }

      it 'subtracts value from credit_card balance' do
        expect{ subject }.to change{@credit_card.reload.balance}.by(-100)
      end

      it 'returns payment info' do
        subject
        payment_response = as_json(response.body)
        expect(payment_response).to include_json(expected_response)
      end

      it 'returns status code 202' do
        subject
        expect(response).to have_http_status(202)
      end
    end

    context 'when card is not paid' do
      context 'when amount that is being paid is too high' do
        let(:payment_attributes) { { payment: { amount: (@credit_card.balance + 1) } } }
        subject { post create_payment_api_v1_me_wallet_cards_path(@credit_card.id, payment_attributes), headers: valid_headers }

        it 'doesnt change credit_card balance' do
          expect{ subject }.to change{@credit_card.reload.balance}.by(0)
        end

        it 'returns the errors' do
          subject
          payment_response = as_json(response.body)
          expect(payment_response).to include_json({credit_card: [I18n.t('cannot_pay_more_than_owes')]})
        end

        it 'returns status code 403' do
          subject
          expect(response).to have_http_status(403)
        end
      end

      context 'when card being paid doesnt belong to user' do
        let(:payment_attributes) { { payment: { amount: (@not_my_card.balance) } } }
        subject { post create_payment_api_v1_me_wallet_cards_path(@not_my_card.id, payment_attributes), headers: valid_headers }

        it 'doesnt change credit_card balance' do
          expect{ subject }.to change{@not_my_card.reload.balance}.by(0)
        end

        it 'returns the errors' do
          subject
          payment_response = as_json(response.body)
          expect(payment_response).to include_json({credit_card: [I18n.t('cannot_pay_credit_card')]})
        end

        it 'returns status code 403' do
          subject
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
