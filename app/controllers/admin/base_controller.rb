class Admin::BaseController < ApplicationController
  layout "admin"

  before_action :ensure_logged_in
  before_action :admin_privlage_required
  #FIXME_AB: you also need to check that user is logged in. like

  #FIXME_AB: make a admin layout and all admin controlers will use admin layout by default
  #FIXME_AB: admin layout will have its own admin.js and admin.css like we have for application layout

  protected

    def admin_privlage_required
      unless current_user.admin?
        redirect_to home_url, notice: 'You must be logged in as an admin to view this page.'
      end
    end

end
