class CreditCard < ApplicationRecord
  belongs_to :wallet
  validates :limit, presence: true, numericality: { greater_than_or_equal_to: 0  }
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0  }
  validates :number, presence: true, numericality: { only_integer: true }
  validates :card_holder, presence: true
  validates :exp_month, presence: true, inclusion: { in: 1..12 }
  validates :exp_year, presence: true, numericality: { greater_than_or_equal_to: Date.today.year }
  validates :payment_due_date, presence: true
  validates :cvv, presence: true, length: { is: 3 }

  validate :enough_limit?,
           :payment_due_date_cannot_be_in_the_past

  before_save :update_remaining_limit

  scope :ordered_by_further_payment_due_date, -> { order(payment_due_date: :desc) }
  scope :ordered_by_smaller_remaining_limit, -> { order(remaining_limit: :asc) }
  scope :with_remaining_limit, -> { where('remaining_limit > 0') }
  scope :candidates_for_purchase, -> { with_remaining_limit
                                      .ordered_by_further_payment_due_date
                                      .ordered_by_smaller_remaining_limit }

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
      errors.add(:payment_due_date, :date_in_past)
    end
  end

  def update_remaining_limit
    self.remaining_limit = limit - balance
  end
end
