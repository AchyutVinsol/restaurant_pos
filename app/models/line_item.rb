# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  price      :decimal(8, 2)
#  meal_id    :integer
#  order_id   :integer
#  quantity   :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_line_items_on_meal_id   (meal_id)
#  index_line_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_2dc2e5c22c  (order_id => orders.id)
#  fk_rails_dc2631faef  (meal_id => meals.id)
#

class LineItem < ActiveRecord::Base
  validates :meal, uniqueness: { scope: :order_id, message: ' already added to cart!' }
  validates_with ActiveMealValidator
  validates_with AvailableMealValidator

  belongs_to :meal
  belongs_to :order
  has_many :extra_items, dependent: :destroy
  accepts_nested_attributes_for :extra_items

  def total
    price + extra_items.inject(0) { |sum, ei| sum + ei.price }
  end

  def set_price
    self.price = meal.price
  end

  def consistent_location?
    current_location == order.location
  end

  #FIXME_LATER: block_inventories and unblock_inventories are very similar!, use yield?
  def block_inventories(inventory_items)
    meal.recipe_items.each do |ri|
      quantity = ingredient_quantity_in_meal(ri)
      inventory_items.where(ingredient_id: ri.ingredient_id).take.decrease_quantity(quantity * self.quantity)
    end
  end

  def unblock_inventories(inventory_items)
    meal.recipe_items.each do |ri|
      quantity = ingredient_quantity_in_meal(ri)
      inventory_items.where(ingredient_id: ri.ingredient_id).take.increase_quantity(quantity * self.quantity)
    end
  end

  def ingredient_quantity_in_meal(ri)
    if extra_items.any? { |ei| ei.ingredient_id == ri.ingredient_id }
      return ri.quantity + 1
    else
      return ri.quantity
    end
  end

  # def unblock_inventories
  #   @inventory_items = order.location.inventory_items
  #   meal.recipe_items.each do |ri|
  #     quantity = 0
  #     if extra_items.any? { |ei| ei.ingredient_id == ri.ingredient_id }
  #       quantity = ri.quantity + 1
  #     else
  #       quantity = ri.quantity
  #     end
  #     @inventory_items.where(ingredient_id: ri.ingredient_id).take.decrease_quantity(quantity * self.quantity)
  #   end
  # end

end
