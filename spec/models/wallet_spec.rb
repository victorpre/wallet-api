require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_numericality_of(:limit).is_greater_than_or_equal_to(0) }

  describe 'max_limit' do
    subject { create(:wallet, :with_credit_cards)  }
    let(:sum) { subject.credit_cards.inject(0.0){|total, cc| total + cc.limit } }

    it 'returns the correct sum of credit_cards limits' do
      expect(subject.max_limit).to eq sum
    end
  end

  describe 'validates that limit is less than max_limit' do
    subject { build(:wallet, :with_credit_cards) }
    let(:bigger_limit) { subject.max_limit + 1.0 }

    it 'is invalid when bigger limit is assigned' do
      subject.limit = bigger_limit
      expect(subject).to be_invalid
    end
  end
end
