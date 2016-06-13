class CreateExtraItems < ActiveRecord::Migration
  def change
    create_table :extra_items do |t|
      t.references :line_item, index: true, foreign_key: true
      t.references :ingredient, index: true, foreign_key: true
      t.decimal :price, precision: 8, scale: 2

      t.timestamps null: false
    end
  end
end
