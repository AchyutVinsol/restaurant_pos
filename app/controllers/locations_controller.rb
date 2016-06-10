class LocationsController < ApplicationController

  #FIXME_DONE: identify private methods

  #FIXME_DONE: this is go in userscontroller#change_prefered_location(member) post then redirect to location#index

  # def create
  #   if params[:location_id].present?
  #     @location = Location.includes(:meals).where(id: params[:location_id]).take
  #     current_user.set_prefered_location(@location.id)
  #   end
  #   get_meal_by_type(params[:meal_type])
  # end

  def index
    @location = current_location
    set_meal_type_filter(params[:meal_type])
    get_meal_by_type(params[:meal_type])
  end

  private

    def get_meal_by_type(preference)
      @meals = current_location.meals.active.includes(:ingredients, :recipe_items)
      @meals = @meals.select { |meal| meal.veg? } if preference == 'Veg'
      @meals = @meals.select { |meal| !meal.veg? } if preference == 'Non-Veg'
      # FIXME_DONE: eagerload data
    end

    # FIXME_DONE: we can write it in a better way
    # FIXME_DONE: make a helper method current_location. similar like current_user

    # if preference == 'Veg'
    #   # current_location.meals.active.veg
    #   @location.meals.active_meals.select { |meal| meal.veg }
    # elsif preference == 'Non-Veg'
    #   # current_location.meals.active.non_veg
    #   @location.meals.active_meals.select { |meal| !meal.veg }
    # else
    #   @location.meals.active_meals
    # end

    #FIXME_DONE: you also need to save preference in session so that you can preselect value

end
