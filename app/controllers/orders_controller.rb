class OrdersController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_order, only: [:show, :place]

  def show
    @line_items = @order.line_items
  end

  def index
    @orders = current_user.orders.includes(:location)
  end

  def place
    @user = current_user
    customer = @user.stripe_customer(params[:stripeToken])

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      @order.price_in_cents,
      description: "Order Id is: #{ @order.id }",
      currency:    'usd'
    )

    if @order.mark_paid(charge, params)
      redirect_to user_order_path(@order), notice: 'Your order has been successfully placed!'
    else
      #FIXME_AB: test the refund by adding a validation in order which fails
      @order.transactions.first.refund
      redirect_to :back, alert: "The order could not be placed because of the following errors. \n #{@order.errors.full_messages.join(', ')}"
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back

  end


  private

    def set_order
      @order = current_order
    end

end
