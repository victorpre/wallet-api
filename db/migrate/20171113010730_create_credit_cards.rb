class CreateCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_cards do |t|
      t.belongs_to :wallet
      t.decimal :limit, null: false, default: 0.0, scale: 2, precision: 12
      t.decimal :balance, null: false, default: 0.0, scale: 2, precision: 12
      t.date :payment_due_date

      t.timestamps
    end
  end
end
