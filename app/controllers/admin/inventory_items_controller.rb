class Admin::InventoryItemsController  < Admin::BaseController
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy, :increase_quantity, :decrease_quantity]

  def index
    @inventory_items = Inventory_item.all
  end

  def show
  end

  def new
    @inventory_item = Inventory_item.new
  end

  def create
    # debugger
    @inventory_item = Inventory_item.new()
    # @inventory_item = Inventory_item.new(inventory_item_params)
    if @inventory_item.save
      redirect_to @inventory_item, notice: 'Successfully added a new inventory item!'
    else
      redirect_to new_inventory_item_path, notice: 'Could not add inventory item because:'
    end
  end

  def edit
  end

  def update
    # debugger
    update_params
    if @inventory_item.update(inventory_params)
      redirect_to @inventory_item, notice: 'inventory item details were successfully updated.'
    else
      redirect_to edit_admin_location_inventory_item_path, notice: 'inventory item update failed because:'
    end
  end

  def destroy
    @inventory_item.destroy
    redirect_to admin_location_inventory_items_path, notice: 'inventory item was successfully destroyed.'
  end

  def increase_quantity
    # if params[:inventory_item][:increase_quantity].present?
    #FIXME_AB: before_acion
    # if inventory_item.increase_quantity(4)
    #   successfully
    # else
    #   failure
    # end
    # debugger
    quantity_increased = params[:increase_quantity]
    @inventory_item.quantity += quantity_increased.to_i
    save_quantity    
    # if @inventory_item.can_increase_quantity?(quantity_increased)
    #   #success
    #   @inventory_item.quantity += quantity_increased
    #   @inventory_item.save
    # else
    #   #faliure
    # end
  end

  def decrease_quantity
    quantity_decreased = params[:decrease_quantity].to_i
    @inventory_item.quantity -= quantity_decreased
    save_quantity
  end

  private

    def save_quantity
      # @inventory_item.save
      respond_to do |format|
        if @inventory_item.save
          # success
          # debugger
          msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
          # format.json { head :ok }
          format.json  { render json: @inventory_item.quantity }
          # format.json  { render json: ok }
          # format.js    { render json: @inventory_item }
        else
          # faliure redirect to some place
        end
      end
    end

    def update_params
      if params[:increase_quantity].present?
        params[:inventory_params][:ingredient_id] = quantity + params[:increase_quantity]
      else
        params[:inventory_params][:ingredient_id] = quantity + params[:decrease_quantity]
      end
      params[:inventory_params][:ingredient_id] = ingredient_id
      params[:inventory_params][:location_id] = location_id
    end

    def set_inventory_item
      @inventory_item = Inventory_item.find(params[:id])
    end

    def inventory_item_params
      params.require(:inventory_item).permit(:ingredient_id, :location_id, :quantity)
    end
end
