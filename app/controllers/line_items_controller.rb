class LineItemsController < ApplicationController

  def show
  end

  def create
    debugger
    @line_item = LineItem.new(line_item_params)
    @line_item.price = @line_item.quantity * @line_item.meal.price
    if @line_item.save
      if params[:can_request_extra].present?
        extra_items_ids = params[:can_request_extra].split(' ')
    debugger
        extra_items_ids.each do |ingredient_id|
    debugger
          if !ExtraItem.new(extra_item_params(ingredient_id)).save
            redirect_to :back
          end
        end
      end
      redirect_to locations_path, notice: "Meal was successfully added!"
    else
      # render current_location
      # stay on this page
      redirect_to :back
    end
    # create the corresponding line items
    # what to do with requests for extra?
  end

  private

    def extra_item_params(ingredient_id)
      { line_item_id: @line_item.id, ingredient_id: ingredient_id, price: Ingredient.where(id: ingredient_id).take.price * @line_item.quantity }
    end

    def line_item_params
      params.permit(:meal_id, :order_id, :quantity)
    end

end
