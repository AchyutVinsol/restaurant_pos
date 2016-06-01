class Admin::IngredientsController < Admin::BaseController
  before_action :set_ingredient, only: [:show, :edit, :update, :destroy]

  def index
    @ingredients = Ingredient.all
  end

  def show
  end

  def new
    @ingredient = Ingredient.new
  end

  def create
    @ingredient = Ingredient.new(ingredient_params)
    if @ingredient.save
      redirect_to [:admin, @ingredient], notice: 'Successfully added a new ingredient!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ingredient.update(ingredient_params)
      redirect_to [:admin, @ingredient], notice: 'Ingredient details were successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @ingredient.destroy
    redirect_to admin_ingredients_path, notice: 'Ingredient was successfully destroyed.'
  end

  private

    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    def ingredient_params
      params.require(:ingredient).permit(:name, :price, :veg, :can_request_extra)
    end

end
