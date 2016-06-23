class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :ensure_logged_in
  before_action :admin_privlage_required

  protected

    def sort_by_pickup(orders)
      orders.to_a.sort! { |a,b| a.pickup_time <=> b.pickup_time }
    end

    def admin_privlage_required
      unless current_user.admin?
        redirect_to home_url, notice: 'You must be logged in as an admin to view this page.'
      end
    end

end
