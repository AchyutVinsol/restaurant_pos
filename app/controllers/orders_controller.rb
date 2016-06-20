class OrdersController < ApplicationController

  #FIXME_DONE: need to be logged in
  before_action :ensure_logged_in, only: [:show, :place]
  before_action :set_order, only: [:show, :place]

  def show
    @line_items = @order.line_items
  end

  def index
    @orders = current_user.orders
  end

  def place
    # @order.pickup_time = params[:pickup_time]
    # @order.contact_number = params[:contact_number]
    @user = current_user
    customer = @user.stripe_customer(params[:stripeToken])

    # debugger
    # customer = Stripe::Customer.create(
    #   :email => params[:stripeEmail],
    #   :source  => params[:stripeToken]
    # )

    charge = Stripe::Charge.create(
      customer:    customer.id,
      #FIXME_DONE: @order.price_in_cents
      amount:      @order.price_in_cents,
      #FIXME_DONE: add more info like order id etc.
      description: "Your Order Id is: #{ @order.id }, Rails Stripe customer",
      currency:    'usd'
    )

    #FIXME_DONE: something like this
    # if @order.mark_paid(charge, params) this will return true false, 
    # this mark_paid will 
    # 1. make a Transaction
    # 2. mark order as paid
    #   redirect_to order's show page with success message
    # else
    #   redirect to back with error message
    #   and refund the Transaction amonut using charge id
    # end
    if @order.mark_paid(charge, params)
      # this mark_paid will: 
      #   1. make a Transaction
      #   2. mark order as paid
      # redirect_to order's show page with success message
      redirect_to user_order_path(@order), notice: 'Your order has been successfully placed!'
    else
      @order.transactions.first.refund
      redirect_to :back, alert: "The order could not be placed because of the following errors. \n #{@order.errors.full_messages.join(', ')}"
      # debugger
      # redirect to back with error message
      # and refund the Transaction amonut using charge id
    end
    # Transaction.create(charge)
    # @order.pay(params[:order], params[:contact_number])

    #FIXME_DONE: after commit in order when order is marked paid from pending
    # UserNotifier.order_placed_email(@order).deliver_now

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back

    # send a mail to user
    # add validation such that if status is not pending, pickup_time should be between working hours!
  end

  # def create
    # debugger
    # @order = current_order || Order.new(order_params)
    # create the corresponding line items
    # what to do with requests for extra?
  # end

  private

    def order_params
      params.permit(:user_id, :location_id)
    end

    def set_order
      @order = current_order
    end

end
