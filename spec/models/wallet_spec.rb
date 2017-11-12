require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:limit) }
  it { is_expected.to validate_numericality_of(:limit).is_greater_than_or_equal_to(0) }
end
