require 'rails_helper'

RSpec.describe Api::V1::Me::CreditCardsController, type: :request do
  before(:each) do
    @user = create(:user)
  end

  let(:wallet) { @user.wallet }

  describe 'POST #create' do
    before do
      post api_v1_me_wallet_cards_path, params: { credit_card: credit_card_attributes }, headers: valid_headers
    end

    let(:credit_card_attributes) { attributes_for :credit_card }

    context 'when credit card is valid' do
      let(:expected_response) { { card_holder: credit_card_attributes[:card_holder],
                                  limit: credit_card_attributes[:limit],
                                  exp_month: credit_card_attributes[:exp_month],
                                  exp_year: credit_card_attributes[:exp_year],
                                  payment_due_date: credit_card_attributes[:payment_due_date].to_s,
                                  number: credit_card_attributes[:number],
                                  cvv: credit_card_attributes[:cvv]} }

      it 'returns info about the card added to wallet' do
        credit_card_response = as_json(response.body)
        expect(credit_card_response).to include_json(expected_response)
      end

      it 'returns status 201' do
        expect(response).to have_http_status(201)
      end
    end

    context 'when credit card is invalid' do
      let(:credit_card_attributes) { attributes_for :credit_card, :invalid_payment_due_date  }
      let(:expected_response) { { limit: [errors_on('credit_card', 'payment_due_date')[:date_in_past]] } }

      it 'returns the error on credit_card' do
        expect(response).to have_http_status(403)
      end

      it 'returns status 403' do
        expect(response).to have_http_status(403)
      end
    end
  end
end
