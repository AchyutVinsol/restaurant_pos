class Inventory_item < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :location

  def can_increase_quantity?(quantity_increased)
    quantity_increased > 0
  end

  def can_decrease_quantity?(quantity_decreased)
    quantity_decreased > quantity
  end

end
