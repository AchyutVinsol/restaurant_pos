class OrderIngredientsQuantityValidator < ActiveModel::Validator
  def validate(order)
    #FIXME_DONE_LATER: Lets revisit after order placement, we need to validate total ingredient qtys at once
    #FIXME_DONE_LATER: This is done but we really don't need this!! since quantity is blocked each time a meal is added!
    # STEPS be like:
    #   1 create a hash {ingredient_id: quantity}
    #   2 check that hash against inventory.

    # location = line_item.order.location

    order_ingredients = {}

    # Get the inventory
    inventory_items = order.location.inventory_items
    # inv = order.location.inventory_items.where(ingredient_id: ri.ingredient_id).take

    #   1 create a hash {ingredient_id: quantity}
    order.line_items.each do |line_item|
      # meal = line_item.meal
      # extras = line_item.extra_items
      line_item.meal.recipe_items.each do |ri|
        ingredient_id = ri.ingredient.id.to_s
        ingredient_quantity = line_item.ingredient_quantity_in_meal(ri)
        if order_ingredients.key?(ingredient_id)
          order_ingredients[ingredient_id] += ingredient_quantity
        else
          order_ingredients[ingredient_id] = ingredient_quantity
        end
      end
    end

    #   2 check that hash against inventory.
    order_ingredients.each do |ingredient_id, ingredient_quantity|
      inventory_item = inventory_items.where(ingredient_id: ingredient_id).take
      if ingredient_quantity > inventory_item.quantity
        order.errors[:location_id] << " has insufficient quantity of #{ inventory_item.ingredient.name } in so inventory!"
        break
      end
    end

  end
end
