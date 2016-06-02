class Admin::LocationsController < Admin::BaseController
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = Location.all
  end

  def show
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(location_params)
    if @location.save
      redirect_to [:admin, @location], notice: 'Successfully added a new locaton!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to [:admin, @location], notice: 'location details were successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @location.destroy
      redirect_to admin_locations_path, notice: 'location was successfully destroyed.'
    else
      redirect_to admin_locations_path, notice: "Unable to destroy location #{ @location.name } because #{ @location.errors[:base] }."
    end
  end

  private

    def set_location
      begin
        @location = Location.find(params[:id])
      rescue ActiveRecord::RecordNotFound  
        redirect_to admin_locations_path, notice: "No location with id #{ params[:id] } found!"
        return
      end
    end

    def location_params
      params.require(:location).permit(:name, :state, :city, :street_first, :street_second, :default, :opening_time, :closing_time)
    end

end
