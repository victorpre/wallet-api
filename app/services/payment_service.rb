class PaymentService
  # TODO: rename to CreditCardService
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

  def make_purchase
    cards = []
    if purchase_allowed?
      cards = select_cards_for_purchase
      @wallet.errors.add(:wallet, "error") unless purchase_with_cards(cards)
    else
      @wallet.errors.add(:wallet ,I18n.t(:purchase_rejected))
    end
    {wallet: @wallet, cards: cards }
  end

  private

  def  select_cards_for_purchase
    @wallet.credit_cards.candidates_for_purchase
  end

  def purchase_with_cards(cards)
    left_to_pay = amount_to_be_paid

    CreditCard.transaction do
      cards.each do |card|
        being_paid = left_to_pay - card.remaining_limit
        if being_paid <= 0
          card.balance = card.balance + left_to_pay
          card.save
          return true
        else
          left_to_pay = being_paid

          # Card is full
          card.balance = card.limit
          card.save
        end
      end
    end
    false
  end

  def purchase_allowed?
    value = amount_to_be_paid
    value > 0 && @wallet.limit >= value && @wallet.available_balance >= value
  end

  def payment_allowed?(card)
    @amount.present? && card.balance >= amount_to_be_paid
  end

  def amount_to_be_paid
    @amount.to_f.abs
  end
end
