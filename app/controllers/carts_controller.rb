class CartsController < ApplicationController

  def create
    @cart = Cart.new
  end

  private

    def set_cart
      @cart = Cart.where(id: params[:id]).take
    end
end
