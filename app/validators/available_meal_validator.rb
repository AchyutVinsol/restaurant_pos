class AvailableMealValidator < ActiveModel::Validator
  def validate(line_item)
    location = line_item.order.location
    meal = line_item.meal
    extras = line_item.extra_items
    meal.recipe_items.each do |ri|
      if extras.any? { |ei| ei.ingredient_id == ri.ingredient_id }
        quantity = ri.quantity + 1
      else
        quantity = ri.quantity
      end
      inv = location.inventory_items.where(ingredient_id: ri.ingredient_id).take
      if quantity > inv.quantity
        line_item.errors[:meal] << " has insufficient quantity in inventory!"
        break
      end
    end
  end

end
