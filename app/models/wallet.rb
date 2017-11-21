class Wallet < ApplicationRecord
  belongs_to :user
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  has_many :credit_cards

  validate :limit_less_than_credit_cards


  def max_limit
    credit_cards.sum(:limit)
  end

  def available_balance
    credit_cards.sum(:remaining_limit)
  end

  def used_balance
    credit_cards.sum(:balance)
  end

  private

  def limit_less_than_credit_cards
    errors.add(:limit, :exceed_max_limit ) if limit > max_limit
  end
end
