class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.boolean :captured, default: true
      t.decimal :amount, precision: 8, scale: 2
      t.references :order, index: true, foreign_key: true
      t.string :last4, default: 'xxxx'
      t.string :brand, default: 'Fake'
      t.string :currency, default: 'usd'
      t.string :card_id, index: true
      t.string :charge_id, index: true
      t.string :customer_id, index: true

      t.timestamps null: false
    end
  end
end
