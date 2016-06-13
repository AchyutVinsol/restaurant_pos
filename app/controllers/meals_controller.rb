class MealsController < ApplicationController
  before_action :set_meal, only: [:show]

  #FIXME_DONE: will be in context of location, always

  def show
    @location = Location.where(id: params[:location_id]).take
  end

  private

    def set_meal
      @meal = Meal.where(id: params[:id]).take
    end

end
