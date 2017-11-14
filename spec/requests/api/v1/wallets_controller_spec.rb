require 'rails_helper'

RSpec.describe Api::V1::WalletsController, type: :request do
  before(:each) do
    @user = create(:user, :with_credit_cards)
    @wallet = @user.wallet
  end

  describe 'GET #show' do
    before do
      get api_v1_wallet_path, headers: valid_headers
    end

    let(:expected_response) { { limit: @wallet.limit.to_s,
                                max_limit: @wallet.max_limit.to_s } }
    it 'returns info about the wallet' do
      wallet_response = as_json(response.body)
      expect(wallet_response).to include_json(expected_response)
    end
  end
end
