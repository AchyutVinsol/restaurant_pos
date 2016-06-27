class OrdersController < ApplicationController

  before_action :ensure_logged_in
  before_action :set_current_order, only: [:show, :place]
  before_action :set_order, only: [:details, :destroy]

  def show
  end

  def details
    @transaction = @order.transactions.first
  end

  def destroy
    if @order.mark_canceled
      redirect_to :back, notice: "Order #{@order.id} has been cancled."
    else
      redirect_to :back, alert: "Order #{@order.id} could not be cancled, because of time restriction ,status or errors. #{@order.errors.full_messages.join(', ')}."
    end
  end

  def index
    @orders = current_user.orders.order(placed_at: :desc).order(pickup_time: :desc).where.not(status: "pending").includes(:location)
  end

  def place
    customer = current_user.stripe_customer(params[:stripeToken])

    charge = Stripe::Charge.create(
      customer:    customer.id,
      amount:      @order.price_in_cents,
      description: "Order Id is: #{ @order.id }",
      currency:    'usd'
    )

    if @order.mark_paid(charge, params)
      redirect_to details_user_order_path(current_user, @order), notice: 'Your order has been successfully placed!'
    else
      @order.transactions.first.refund
      debugger
      redirect_to :back, alert: "The order could not be placed because of the following errors. \n #{@order.errors.full_messages.join(', ')}"
    end

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back

  end

  private

    def set_current_order
      @order = current_order
    end

    def set_order
      @order = current_user.orders.where(id: params[:id]).take
    end

end
