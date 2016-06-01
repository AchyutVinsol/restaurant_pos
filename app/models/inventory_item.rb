class InventoryItem < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :location

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def can_increase_quantity?(quantity_increased)
    quantity_increased > 0
  end

  def can_decrease_quantity?(quantity_decreased)
    quantity_decreased > quantity
  end

end
