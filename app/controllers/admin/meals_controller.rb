class Admin::MealsController < Admin::BaseController
  before_action :set_meal, only: [:show, :edit, :update, :destroy, :change_status]

  def index
    @meals = Meal.includes(:recipe_items).all
  end

  def show
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = Meal.new(meal_params)
    if @meal.save
      redirect_to [:admin, @meal], notice: 'Successfully added a new meal!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @meal.update(meal_params)
      redirect_to [:admin, @meal], notice: 'meal details were successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @meal.destroy
      redirect_to admin_meals_path, notice: 'meal was successfully destroyed.'
    else
      redirect_to admin_meals_path, notice: "Unable to destroy meal #{ @meal.name } because #{ @meal.errors[:base] }."
    end
  end

  def change_status
    if @meal.toogle_status
      render json: { status: 'success', active: @meal.active }
    else
      render json: { status: 'error', errors: @meal.errors.full_messages }
    end
  end

  private

    def set_meal
      begin
        @meal = Meal.includes(:recipe_items).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to admin_meals_path, notice: "No meal with id #{ params[:id] } found!"
        return
      end
    end

    def meal_params
      params.require(:meal).permit(:name, :image, :active, :price, recipe_items_attributes: [:id, :ingredient_id, :meal_id, :quantity, :_destroy])
    end

end
