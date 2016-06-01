class Admin::InventoryItemsController  < Admin::BaseController
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy, :increase_quantity, :decrease_quantity]

  def index
    # debugger
    if params[:location_id].present?
      @inventory_items = Inventory_item.find_by(location_id: params[:location_id])
    elsif params[:ingredient_id].present?
      @inventory_items = Inventory_item.find_by(ingredient_id: params[:ingredient_id])
    else
      flash[:notice] = 'All inventory items displayed!'
      @inventory_items = Inventory_item.all
    end
    if @inventory_items.nil?
      #FIXME_AB: remove this if on repairing the inventory
      flash[:notice] = "The inventory for the corresponding foreign key id is empty! #{ params }"
      @inventory_items = Inventory_item.all
    end
  end

  def show
  end

  def new
    @inventory_item = Inventory_item.new
  end

  def create
    @inventory_item = Inventory_item.new()
    if @inventory_item.save
      redirect_to @inventory_item, notice: 'Successfully added a new inventory item!'
    else
      render :new
    end
  end

  def edit
  end

  def update
    update_params
    if @inventory_item.update(inventory_params)
      redirect_to @inventory_item, notice: 'inventory item details were successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @inventory_item.destroy
    redirect_to admin_location_inventory_items_path, notice: 'inventory item was successfully destroyed.'
  end

  def increase_quantity
    quantity_increased = params[:increase_quantity]
    @inventory_item.quantity += quantity_increased.to_i
    save_quantity    
  end

  def decrease_quantity
    quantity_decreased = params[:decrease_quantity].to_i
    @inventory_item.quantity -= quantity_decreased
    save_quantity
  end

  private

    def save_quantity
      respond_to do |format|
        if @inventory_item.save
          msg = { :status => "ok", :message => "Success!", :html => "<b>...</b>" }
          format.json  { render json: @inventory_item.quantity }
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
