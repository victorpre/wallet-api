class Wallet < ApplicationRecord
  belongs_to :user
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0 }
  has_many :credit_cards

  validate :limit_less_than_credit_cards


  def max_limit
    credit_cards.sum(:limit)
  end

  private

  def limit_less_than_credit_cards
    errors.add(:limit, "can't' be greater than credit cards limits.") if limit > max_limit
  end
end
