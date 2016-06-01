class CreateInventoryItems < ActiveRecord::Migration
  def change
    create_table :inventory_items do |t|
      t.references :location, index: true, foreign_key: true
      t.references :ingredient, index: true, foreign_key: true
      t.decimal :quantity
      t.timestamps null: false
    end
  end
end
