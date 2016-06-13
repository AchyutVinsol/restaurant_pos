class OrdersController < ApplicationController

  def show
  end

  def create
    debugger
    # @order = current_order || Order.new(order_params)
    # create the corresponding line items
    # what to do with requests for extra?
  end

  private

    def order_params
      params.permit(:user_id)
    end

end
