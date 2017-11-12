require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_confirmation_of(:password) }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_uniqueness_of(:auth_token) }
  it { is_expected.to have_one(:wallet) }

  describe 'generate_auth_token' do
    subject{ create :user }

    it 'changes the current auth_token' do
      old_token = subject.auth_token
      expect(subject.generate_auth_token).not_to eq old_token
    end
  end

  describe 'expire_auth_token!' do
    subject{ create(:user) }

    it 'changes the auth_token to nil' do
      subject.expire_auth_token!
      expect(subject.auth_token).to be_nil
    end
  end

  describe 'when created' do
    subject{ create(:user) }

    it 'has a wallet ' do
      expect(subject.wallet).not_to be_nil
    end
  end
end
