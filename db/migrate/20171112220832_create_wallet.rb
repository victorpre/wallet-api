class CreateWallet < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.belongs_to :user, index: true

      t.decimal :limit, null: false, default: 0.0, scale: 2, precision: 12
    end
  end
end
