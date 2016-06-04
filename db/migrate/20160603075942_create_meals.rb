class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.string :name, unique: true, index: true
      t.decimal :price, precision: 8, scale: 2
      t.attachment :image
      t.timestamps null: false
    end
  end
end
