class Admin::PosController < Admin::BaseController
  layout 'pos'

  def index
    @user = current_user
    @location = Location.where(name: params[:location_name]).take
    @orders = @location.orders.where.not(status: 0)
    # debugger
    @orders = @orders.to_a.sort! { |a,b| a.pickup_time <=> b.pickup_time }
  end

  def deliver
    # debugger
    @location = Location.where(id: params[:location_id]).take
    @order = @location.orders.where(id: params[:order_id]).take
    @order.mark_delivered
    redirect_to :back
  end

end
