class AddPaymentPropertiestoCreditCards < ActiveRecord::Migration[5.1]
  def change
    add_index(:credit_cards, :wallet_id)
    add_column(:credit_cards, :number, :string, null: false)
    add_column(:credit_cards, :card_holder, :string, null: false)
    add_column(:credit_cards, :cvv, :integer, null: false)
    add_column(:credit_cards, :expiration_date, :date)

    add_column(:credit_cards, :remaining_limit, :decimal, null: false, default: 0.0, scale: 2, precision: 12)
  end
end
