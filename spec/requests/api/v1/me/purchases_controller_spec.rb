require 'rails_helper'

RSpec.describe Api::V1::Me::PurchasesController, type: :request do
  describe 'POST #create' do
    before(:each) do
      @user = create :user
      @credit_card = create(:credit_card,
                            limit: 4000,
                            balance: 0,
                            wallet: @user.wallet,
                            payment_due_date: (Date.today+1.month))

      create_list(:credit_card, 2,
                  limit: 500,
                  balance: 0,
                  wallet: @user.wallet,
                  payment_due_date: (Date.today+2.months))

      @user.wallet.update_attributes(limit: 5000)
    end

    subject { post create_purchase_api_v1_me_wallet_path(nil, purchase_attributes), headers: valid_headers }

    context 'when there is enough balance in multiples cards' do

      let(:purchase_attributes) { { purchase: { amount: 5000 } } }
      let(:expected_response) { { paid: '5000',
                                  cards_ids: (@user.wallet.credit_cards.pluck :id).sort ,
      } }

      it 'increments the value in balance' do
        expect{ subject }.to change{@credit_card.reload.balance}.by(4000)
      end

      it 'returns status code 201' do
        subject
        expect(response).to have_http_status(201)
      end

      it 'returns the paid value in response' do
        subject
        purchase_response = as_json(response.body)
        expect(purchase_response[:paid]).to eq expected_response[:paid]
      end

      it 'returns the cards used in response' do
        subject
        purchase_response = as_json(response.body)
        expect(purchase_response[:cards_ids].sort).to eq expected_response[:cards_ids]
      end

    end

    context 'when there is not enough balance' do
      let(:purchase_attributes) { { purchase: { amount: 5001 } } }

      it 'returns errors about max_limit exceeded' do
        subject
        purchase_reponse = as_json(response.body)
        expect(purchase_reponse).to include_json({wallet: [I18n.t('purchase_rejected')]})
      end

      it 'returns status 403' do
        subject
        expect(response).to have_http_status(403)
      end
    end

    context 'when amount is less than limit' do
      context 'when available_balance + amount is greater than limit' do
        let!(:purchase_attributes) { { purchase: { amount: 5000 } } }

        before do
          post create_purchase_api_v1_me_wallet_path(nil, purchase_attributes), headers: valid_headers
        end

        it 'returns errors about max_limit exceeded' do
          subject
          purchase_reponse = as_json(response.body)
          expect(purchase_reponse).to include_json({wallet: [I18n.t('purchase_rejected')]})
        end

        it 'returns status 403' do
          subject
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
