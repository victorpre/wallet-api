class CreditCard < ApplicationRecord
  belongs_to :wallet
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0  }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0  }

  validate :enough_limit?, :payment_due_date_cannot_be_in_the_past

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
end
