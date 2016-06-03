# == Schema Information
#
# Table name: inventory_items
#
#  id            :integer          not null, primary key
#  location_id   :integer
#  ingredient_id :integer
#  quantity      :decimal(10, )
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_inventory_items_on_ingredient_id  (ingredient_id)
#  index_inventory_items_on_location_id    (location_id)
#
# Foreign Keys
#
#  fk_rails_6329e56072  (location_id => locations.id)
#  fk_rails_b91f5fc4dc  (ingredient_id => ingredients.id)
#

class InventoryItem < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :location

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, uniqueness: { scope: [:location_id, :ingredient_id] }

  def increase_quantity(value)
    self.quantity += value
    boolean_save
  end

  def decrease_quantity(value)
    self.quantity -= value
    boolean_save
  end

  def boolean_save
    if save
      return true
    else
      return false
    end
  end

end
