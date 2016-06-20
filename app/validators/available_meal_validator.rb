class AvailableMealValidator < ActiveModel::Validator
  def validate(line_item)
    #FIXME_DONE_LATER: Lets revisit after order placement, we need to validate total ingredient qtys at once
    # STEPS be like:
    #   1 create a hash {ingredient_name: quantity}
    #   2 check that hash against inventory.

    # Get the inventory
    # location = line_item.order.location
    inventory_items = line_item.order.location.inventory_items
    meal = line_item.meal
    extras = line_item.extra_items
    meal.recipe_items.each do |ri|
      quantity = line_item.ingredient_quantity_in_meal(ri)
      inv = inventory_items.where(ingredient_id: ri.ingredient_id).take
      if quantity > inv.quantity
        line_item.errors[:meal] << " has insufficient quantity in inventory!"
        break
      end
    end
  end
end
