require 'rails_helper'

RSpec.describe Api::V1::Me::WalletsController, type: :request do
  before(:each) do
    @user = create(:user, :with_credit_cards)
  end

  let(:wallet) { @user.wallet }

  describe 'GET #show' do
    before do
      get api_v1_me_wallet_path, headers: valid_headers
    end

    let(:expected_response) { { limit: wallet.limit.to_s,
                              max_limit: wallet.max_limit.to_s } }

    it 'returns info about the wallet' do
      wallet_response = as_json(response.body)
      expect(wallet_response).to include_json(expected_response)
    end
  end

  describe 'PUT #update' do
    context 'when limit is allowed' do
      before do
        params = { wallet: { limit: wallet.max_limit.to_s }}
        put api_v1_me_wallet_path(nil, params), headers: valid_headers
      end

      let(:expected_response) { { limit: wallet.reload.limit.to_s,
                                  max_limit: wallet.reload.max_limit.to_s } }

      it 'returns updated info about the wallet' do
        wallet_response = as_json(response.body)
        expect(wallet_response).to include_json(expected_response)
      end

      it 'returns status 202' do
        expect(response).to have_http_status(202)
      end
    end
  end

  context 'when limit is not allowed' do
    before do
      limit_too_big = wallet.max_limit + 1
      params = { wallet: { limit: limit_too_big.to_s }}
      put api_v1_me_wallet_path(nil, params), headers: valid_headers
    end

    let(:expected_response) { { limit: [errors_on('wallet', 'limit')[:exceed_max_limit]] } }

    it 'returns errors about max_limit exceeded' do
      wallet_response = as_json(response.body)
      expect(wallet_response).to include_json(expected_response)
    end

    it 'returns status 403' do
      expect(response).to have_http_status(403)
    end
  end
end
