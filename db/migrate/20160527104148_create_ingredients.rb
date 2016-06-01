class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name, unique: true, index: true
      t.decimal :price, precision: 8, scale: 2
      t.boolean :veg, default: true
      t.boolean :can_request_extra, default: false
      t.timestamps null: false
    end
  end
end
