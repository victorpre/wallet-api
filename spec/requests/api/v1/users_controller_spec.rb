require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do

  before(:each) do
    @user = create(:user)
  end

  describe "GET #show" do
    before { get api_v1_user_path(@user.id) }

    it 'returns the user' do
      user_email = as_json(response.body)[:email]
      expect(user_email).to eq @user.email
    end
  end
end
