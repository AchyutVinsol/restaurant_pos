class MealsController < ApplicationController
  before_action :set_meal, only: [:show]

  def show
    @location = Location.where(id: params[:location_id]).take
  end

  private

    def set_meal
      @meal = Meal.where(id: params[:id]).take
    end

end
