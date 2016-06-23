class LocationsController < ApplicationController

  def index
    @location = current_location
    set_meal_type_filter(params[:meal_type])
    get_meal_by_type(params[:meal_type])
  end

  def change
    session[:location] = params[:location_id]
    current_user.set_prefered_location(params[:location_id]) if signed_in?
    redirect_to :back 
  end

  private

    def get_meal_by_type(preference)
      # debugger
      @meals = @location.meals.active.includes(:ingredients, :recipe_items)
      @meals = @meals.select { |meal| meal.veg? } if preference == 'Veg'
      @meals = @meals.select { |meal| !meal.veg? } if preference == 'Non-Veg'
      @meals = @meals.select { |meal| meal.available?(@location) }
    end

end
