class Admin::InventoryItemsController  < Admin::BaseController
  before_action :set_inventory_item, only: [:show, :edit, :update, :destroy, :increase_quantity, :decrease_quantity]

  def index

    #FIXME_AB: 1. find the parent resource i.e ingredient or location in the before action @resource. redirect to back or home page if @resource is nil
    #FIXME_AB: 2. @inventory_items = @resource.inventory_items

    if params[:location_id].present?
      @inventory_items = InventoryItem.find_by(location_id: params[:location_id])
    elsif params[:ingredient_id].present?
      @inventory_items = InventoryItem.find_by(ingredient_id: params[:ingredient_id])
    else
      #FIXME_AB: no such case
      flash[:notice] = 'All inventory items displayed!'
      @inventory_items = InventoryItem.all
    end
    # if @inventory_items.nil?
    #   #FIXME_AB: remove this if on repairing the inventory
    #   flash[:notice] = "The inventory for the corresponding foreign key id is empty! #{ params }"
    #   @inventory_items = InventoryItem.all
    # end
  end

  #FIXME_AB: we don't need show
  def show
  end

  #FIXME_AB: we don't need new
  def new
    @inventory_item = InventoryItem.new
  end

  #FIXME_AB: not needed
  def create
    @inventory_item = InventoryItem.new()
    if @inventory_item.save
      redirect_to @inventory_item, notice: 'Successfully added a new inventory item!'
    else
      render :new
    end
  end

  #FIXME_AB: not needed
  def edit
  end

  #FIXME_AB: not needed
  def update
    update_params
    if @inventory_item.update(inventory_params)
      redirect_to @inventory_item, notice: 'inventory item details were successfully updated.'
    else
      render :edit
    end
  end

  #FIXME_AB: not needed. 
  def destroy
    @inventory_item.destroy
    redirect_to admin_location_inventory_items_path, notice: 'inventory item was successfully destroyed.'
  end

  def increase_quantity
    quantity_increased = params[:increase_quantity]
    @inventory_item.quantity += quantity_increased.to_i
    #FIXME_AB: why don't you do this @inventory_item.increase_quantity(params[:increase_quantity].to_i). This should return true false, based on this we'll prepare our response {status: success, qty: 50}, {status: error, errors: [...]}
    save_quantity    
  end

  def decrease_quantity
    #FIXME_AB: same as above
    quantity_decreased = params[:decrease_quantity].to_i
    @inventory_item.quantity -= quantity_decreased
    save_quantity

    # if @inventory_item.decrease_quantity(params.to_i)
    #   render json: {status: "success", qty: @inventory_items.qty}
    # else
    #   render json{}
    # end

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

    #FIXME_AB: not needed
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
      @inventory_item = InventoryItem.find(params[:id])
      #FIXME_AB: what if not found
    end

    def inventory_item_params
      params.require(:inventory_item).permit(:ingredient_id, :location_id, :quantity)
    end
end
