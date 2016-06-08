class CreateRecipeItems < ActiveRecord::Migration
  def change
    create_table :recipe_items do |t|
      t.references :ingredient, index: true, foreign_key: true
      t.references :meal, index: true, foreign_key: true
      t.decimal :quantity
      t.timestamps null: false
    end
  end
end
