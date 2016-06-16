class LineItemsController < ApplicationController

  before_action :set_order
  before_action :ensure_logged_in, only: [:create]

  def create
    @line_item = @order.line_items.new(line_item_params)
    if params[:extra_ingridents].present?
      params[:extra_ingridents].each do |ingredient_id|
        @line_item.extra_items.build(extra_item_params(ingredient_id))
      end
    end
    if @line_item.save
      @line_item.order.save
      #FIXME_DONE: redirect user to order's show page
      redirect_to user_order_path(current_user, @order), notice: "Meal was successfully added!"
    else
      redirect_to :back
    end
  end

  private

    def extra_item_params(ingredient_id)
      { line_item_id: @line_item.id, ingredient_id: ingredient_id, price: @line_item.meal.ingredients.where(id: ingredient_id).take.price }
    end

    def line_item_params
      params.permit(:order_id ,:meal_id, :quantity)
    end

    def set_order
      #FIXME_DONE: current_user.orders.pending.where......
      @order = current_user.orders.pending.where(id: params[:order_id]).take
    end

end
