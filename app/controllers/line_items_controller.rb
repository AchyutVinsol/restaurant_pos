class LineItemsController < ApplicationController

  #FIXME_AB: who can perform these actions

  before_action :set_order

  def show
  end

  def create
    @line_item = @order.line_items.new(line_item_params)
    #FIXME_AB: this is a model's work. before_save copy meal's price to price
    @line_item.price = @line_item.quantity * @line_item.meal.price
    if params[:extra_ingridents].present?
      params[:extra_ingridents].each do |ingredient_id|
        @line_item.extra_items.build(extra_item_params(ingredient_id))
      end
    end
    if @line_item.save
      redirect_to locations_path, notice: "Meal was successfully added!"
    else
      redirect_to :back
    end
  end

  private

    def extra_item_params(ingredient_id)
      #FIXME_AB: meal.ingridients
      { line_item_id: @line_item.id, ingredient_id: ingredient_id, price: Ingredient.where(id: ingredient_id).take.price * @line_item.quantity }
    end

    def line_item_params
      params.permit(:order_id ,:meal_id, :quantity)
    end

    def set_order
      #FIXME_AB: should be current_user.orders.where.....
      @order = Order.where(id: params[:order_id]).take
    end

end
