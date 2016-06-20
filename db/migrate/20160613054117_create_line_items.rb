class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.decimal :price, precision: 8, scale: 2
      t.references :meal, index: true, foreign_key: true
      t.references :order, index: true, foreign_key: true
      t.decimal :quantity

      t.timestamps null: false
    end
  end
end
