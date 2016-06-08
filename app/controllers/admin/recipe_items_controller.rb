class Admin::RecipeItemsController < Admin::BaseController
  before_action :set_recipe_item, only: [:show, :edit, :update, :destroy]

  def index
    @recipe_items = RecipeItem.all
  end

  def show
  end

  def new
    @recipe_item = RecipeItem.new
  end

  def create
    @recipe_item = RecipeItem.new(recipe_item_params)
    if @recipe_item.save
      redirect_to [:admin, @recipe_item], notice: 'Successfully added a new locaton!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @recipe_item.update(recipe_item_params)
      redirect_to [:admin, @recipe_item], notice: 'recipe_item details were successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @recipe_item.destroy
      redirect_to admin_recipe_items_path, notice: 'recipe_item was successfully destroyed.'
    else
      redirect_to admin_recipe_items_path, notice: "Unable to destroy recipe_item #{ @recipe_item.name } because #{ @recipe_item.errors[:base] }."
    end
  end

  private

    def set_recipe_item
      begin
        @recipe_item = RecipeItem.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to admin_recipe_items_path, notice: "No recipe_item with id #{ params[:id] } found!"
        return
      end
    end

    def recipe_item_params
      params.require(:recipe_item).permit(:id, :ingredient_id, :meal_id, :quantity)
    end

end
