require 'rails_helper'

RSpec.describe CreditCard, type: :model do
  it { is_expected.to belong_to(:wallet) }
  it { is_expected.to validate_numericality_of(:limit).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:balance).is_greater_than_or_equal_to(0) }
  it { is_expected.to validate_numericality_of(:number).only_integer }
  it { is_expected.to validate_presence_of(:card_holder) }
  it { is_expected.to validate_presence_of(:cvv) }
  it { is_expected.to validate_presence_of(:expiration_date) }

  describe 'has a valid payment_due_date' do
    subject { build(:credit_card, payment_due_date: Faker::Date.forward(1)) }
    let(:invalid_subject) { build(:credit_card, payment_due_date: Faker::Date.backward(1)) }

    it 'is valid when not in the past' do
      expect(subject).to be_valid
    end

    it 'is invalid when in the past' do
      expect(invalid_subject).to be_invalid
    end
  end

  describe 'has a valid expiration_date ' do
    subject { build(:credit_card, expiration_date: Faker::Date.forward(1)) }
    let(:invalid_subject) { build(:credit_card, expiration_date: Faker::Date.backward(1)) }

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

  describe 'remaining_limit update' do
    subject { create(:credit_card, limit: 100, balance: 50) }

    it 'has the remaining_limit set automatically on create' do
      expect(subject.remaining_limit.to_f).to be 50.0
    end

    it 'has the remaining_limit set automatically on update' do
      subject.balance = subject.balance + 1.0
      expect{ subject.save }.to change{ subject.remaining_limit }.by(-1.0)
    end
  end
end
