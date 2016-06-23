class Admin::PosController < Admin::BaseController
  layout 'pos'

  before_action :set_location

  def index
    # debugger
    @orders = @location.orders.not_pending.order(:pickup_time)
  end

  def deliver
    @order = @location.orders.where(id: params[:order_id]).take
    if @order.mark_delivered
      redirect_to :back, notice: "Order ID:#{@order.id} was delivered!"
    else
      redirect_to :back, alert: "Unable to mark order ID:#{@order.id} as delivered due to the following reasons. #{@order.errors.full_messages.join(', ')}"
    end
  end

  private

    def set_location
      if params[:location_name].nil?
        @location = Location.where(id: params[:location_id]).take
      else
        @location = Location.where(name: params[:location_name]).take
      end
    end

end
