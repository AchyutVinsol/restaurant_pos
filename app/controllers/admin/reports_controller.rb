class Admin::ReportsController < Admin::BaseController

  before_action :set_location

  #FIXME_DONE: refactor
  def show
    meal_hash = Location
      .includes(orders: {line_items: :meal})
      .where("locations.id = ?", params[:location_id])
      .where("orders.status = ?", statuses[:delivered]).references(:orders)
      .group('meals.id').count
    if meal_hash.present?
      @meal = Meal.where(id: meals_hash.max_by{|k,v| v}[0]).take
    end

    meal_hash = Location
      .includes(orders: {line_items: :meal})
      .where("locations.id = ?", params[:location_id])
      .where("orders.status = ?", statuses[:delivered]).references(:orders)
      .where("orders.placed_at >= ?", 1.day.ago.end_of_day)
      .group('meals.id').count
    if meal_hash.present?
      @meal_day = Meal.where(id: meals_hash.max_by{|k,v| v}[0]).take
    end
  end

  private

    def set_location
      @location = Location.where(id: params[:location_id]).take
    end


end
