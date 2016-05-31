class Admin::BaseController < ApplicationController
  before_action :admin_privlage_required

  protected

    def admin_privlage_required
      unless current_user.admin?
        flash[:notice] = 'You must be logged in as an admin to view this page.'
        redirect_to home_url
      end
    end

end
