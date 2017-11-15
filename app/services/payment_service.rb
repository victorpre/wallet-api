class PaymentService
  def initialize(card, params)
    @credit_card = card
    @amount = params[:amount]
  end

  def make_payment
    if payment_allowed?
      @credit_card.balance = @credit_card.balance - amount_to_be_paid
      @credit_card.save
    end
    @credit_card
  end

  private

  def payment_allowed?
    (@credit_card.balance >= amount_to_be_paid )? true : (@credit_card.errors.add(:credit_card ,I18n.t(:cannot_pay_more_than_owes)); false)
  end

  def amount_to_be_paid
    return false if @amount.empty?
    @amount.to_f.abs
  end
end
