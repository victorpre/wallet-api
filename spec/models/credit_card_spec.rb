require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it { is_expected.to belong_to(:wallet) }
  it { is_expected.to validate_numericality_of(:limit).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }

  describe 'has a valid payment_due_date' do
    subject { build(:credit_card, payment_due_date: Faker::Date.forward(1)) }
    let(:invalid_subject) { build(:credit_card, payment_due_date: Faker::Date.backward(1) ) }

    it 'is valid when not in the past' do
      expect(subject).to be_valid
    end

    it 'is invalid when in the past' do
      expect(invalid_subject).to be_invalid
    end
  end

  describe 'has a valid balance' do
    subject { build(:credit_card, :valid_balance) }
    let(:invalid_subject) { build(:credit_card, :invalid_balance) }

    it 'is valid when balance is smaller than limit' do
      expect(subject).to be_valid
    end

    it 'is invalid when balance is greater than limit' do
      expect(invalid_subject).to be_invalid
    end
  end
end
