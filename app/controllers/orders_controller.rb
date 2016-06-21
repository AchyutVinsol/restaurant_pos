class OrdersController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_order, only: [:show, :place]

  def show
    @line_items = @order.line_items
  end

  def details
    # debugger
    @user = current_user
    @order = @user.orders.where(id: params[:id]).take
    @transaction = @order.transactions.first
  end

  def destroy
    @user = current_user
    @order = @user.orders.where(id: params[:id]).take
    @order.mark_canceled
    redirect_to user_orders_path(@user)
    # @order.destroy
  end

  def index
    @user = current_user
    @orders = @user.orders.where.not(status: "pending").includes(:location)
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
      redirect_to user_order_path(@user, @order), notice: 'Your order has been successfully placed!'
    else
      #FIXME_DONE: test the refund by adding a validation in order which fails
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
      # @order = Order.where(id: parms[:id]).take
    end

end
