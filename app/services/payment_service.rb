class PaymentService
  def initialize(wallet, params)
    @wallet = wallet
    @amount = params[:amount]
  end

  def pay_credit_card_bill(card)
    return if card.nil?
    credit_card = card
    if payment_allowed?(credit_card)
      credit_card.balance = credit_card.balance - amount_to_be_paid
      credit_card.save
    else
      credit_card.errors.add(:credit_card ,I18n.t(:cannot_pay_more_than_owes))
    end
    credit_card
  end

  private

  def payment_allowed?(card)
    @amount.present? && card.balance >= amount_to_be_paid
  end

  def amount_to_be_paid
    @amount.to_f.abs
  end
end
