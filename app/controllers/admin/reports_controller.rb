class Admin::ReportsController < Admin::BaseController

  before_action :set_location

  def show
    # debugger
    meals_sold = Hash.new(0)
    @location.orders.delivered.each do |order|
      order.meals.each do |meal|
        meals_sold[meal.id.to_s] += 1
      end
    end
    @meal = Meal.where(id: meals_sold.max_by{|k,v| v}[0]).take
    # @meals_sold = Hash[@meals_sold.sort_by{|k, v| v}.reverse]

    meals_sold = Hash.new(0)
    # debugger
    @location.orders.delivered.select{|order| order.placed_at.end_of_day == 1.day.ago.end_of_day}.each do |order|
      order.meals.each do |meal|
        meals_sold[meal.id.to_s] += 1
      end
    end
    if meals_sold.present?
      @meal_day = Meal.where(id: meals_sold.max_by{|k,v| v}[0]).take
    end
  end

  private

    def set_location
      @location = Location.where(id: params[:location_id]).take
    end


end
