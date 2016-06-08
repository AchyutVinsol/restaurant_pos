# == Schema Information
#
# Table name: recipe_items
#
#  id            :integer          not null, primary key
#  ingredient_id :integer
#  meal_id       :integer
#  quantity      :decimal(10, )
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_recipe_items_on_ingredient_id  (ingredient_id)
#  index_recipe_items_on_meal_id        (meal_id)
#
# Foreign Keys
#
#  fk_rails_6297439352  (ingredient_id => ingredients.id)
#  fk_rails_b140456559  (meal_id => meals.id)
#

class RecipeItem < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :meal
  has_many :inventory_items, through: :ingredient
end
