module LocationsHelper

  def meal_ingredients(meal)
    meal.ingredients.map(&:name).join(", ")
  end

end
