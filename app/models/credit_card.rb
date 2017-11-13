class CreditCard < ApplicationRecord
  belongs_to :wallet
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0  }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0  }
  validates :number, presence: true, numericality: { only_integer: true }
  validates :card_holder, presence: true
  validates :expiration_date, presence: true
  validates :cvv, presence: true, length: { is: 3 }

  validate :enough_limit?,
           :payment_due_date_cannot_be_in_the_past,
           :expiration_date_cannot_be_in_the_past

  before_save :update_remaining_limit

  def name
    card_holder
  end

  def user
    wallet.user
  end

  private

  def enough_limit?
    errors.add(:limit, 'is insufficient.') if balance > limit
  end

  def payment_due_date_cannot_be_in_the_past
    if payment_due_date && payment_due_date < Date.today
      errors.add(:payment_due_date, "can't' be in the past.")
    end
  end

  def expiration_date_cannot_be_in_the_past
    if expiration_date && expiration_date < Date.today
      errors.add(:expiration_date, "can't' be in the past. Card expired.")
    end
  end

  def update_remaining_limit
    self.remaining_limit = limit - balance
  end
end
