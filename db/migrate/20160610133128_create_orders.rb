class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :user, index: true, foreign_key: true
      t.references :location, index: true, foreign_key: true
      t.timestamp :expiry_at
      t.timestamp :placed_at
      t.timestamp :pickup_time
      t.integer :status, default: 0
      t.string :contact_number, default: '99999'
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
