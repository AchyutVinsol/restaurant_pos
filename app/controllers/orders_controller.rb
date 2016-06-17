class OrdersController < ApplicationController

  before_action :set_order, only: [:show, :place]
  # after_action :reduce_inventory, only: [:place]

  def show
    @line_items = @order.line_items
    # @extra_items = @line_item.extra_items
  end

  def place
    # @order.pickup_time = params[:pickup_time]
    # @order.contact_number = params[:contact_number]
    @user = current_user
    @order.pay(params[:order], params[:contact_number])
    customer = @user.stripe_customer(params[:stripeToken])

    # debugger
    # customer = Stripe::Customer.create(
    #   :email => params[:stripeEmail],
    #   :source  => params[:stripeToken]
    # )

    debugger
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => (@order.price * 100).to_i,
      :description => 'Rails Stripe customer',
      :currency    => 'usd'
    )

    UserNotifier.order_placed_email(@user, @order).deliver_now

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to :back

    Transaction.create(charge)

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
