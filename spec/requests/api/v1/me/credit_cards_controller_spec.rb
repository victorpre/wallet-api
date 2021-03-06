require 'rails_helper'

RSpec.describe Api::V1::Me::CreditCardsController, type: :request do
  describe 'POST #create' do
    before do
      @user = create(:user)
      post api_v1_me_wallet_cards_path, params: { credit_card: credit_card_attributes }, headers: valid_headers
    end

    let(:wallet) { @user.wallet }
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
      let(:credit_card_attributes) { attributes_for :credit_card, :invalid_payment_due_date }
      let(:expected_response) { { limit: [errors_on('credit_card', 'payment_due_date')[:date_in_past]] } }

      it 'returns the error on credit_card' do
        expect(response).to have_http_status(403)
      end

      it 'returns status 403' do
        expect(response).to have_http_status(403)
      end
    end
  end

  describe 'DELETE #destroy' do
    before do
      @user = create(:user, :with_credit_cards)
      @not_my_user = create(:user, :with_credit_cards)

    end

    let(:credit_card) { @user.wallet.credit_cards.first }

    context 'when card is deleted succesfully' do
      subject { delete api_v1_me_wallet_cards_path, params: { id: credit_card.id }, headers: valid_headers }

      it 'remove card from DB' do
        expect{subject}.to change{CreditCard.count}.by(-1)
      end

      it 'returns status 204' do
        subject
        expect(response).to have_http_status(204)
      end
    end

    context 'when card cant be deleted' do
      let(:credit_card) { @not_my_user.wallet.credit_cards.first }
      subject { delete api_v1_me_wallet_cards_path, params: { id: credit_card.id }, headers: valid_headers }

      it 'doesnt change DB' do
        expect{subject}.to change{CreditCard.count}.by(0)
      end

      it 'returns status 403' do
        subject
        expect(response).to have_http_status(403)
      end

      it 'returns error message' do
        subject
        credit_card_response = as_json(response.body)
        expect(credit_card_response).to include_json({credit_card: [I18n.t('cannot_delete_credit_card')]})
      end
    end
  end
end
