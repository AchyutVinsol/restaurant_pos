class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.boolean :captured, default: true
      t.decimal :amount, precision: 8, scale: 2
      t.references :order, index: true, foreign_key: true
      t.integer :charge_id, index: true

      t.timestamps null: false
    end
  end
end
