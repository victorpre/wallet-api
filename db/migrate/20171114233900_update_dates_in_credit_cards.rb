class UpdateDatesInCreditCards < ActiveRecord::Migration[5.1]
  def change
    remove_column(:credit_cards, :expiration_date)
    add_column(:credit_cards, :exp_month, :integer, null: false)
    add_column(:credit_cards, :exp_year, :integer, null: false)
    change_column(:credit_cards, :payment_due_date, :date, null: false)
  end
end
