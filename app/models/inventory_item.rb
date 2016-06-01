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

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  #FIXME_AB: validates uniquness of qty scope with location and ingredient

  #FIXME_AB: both these methods not requried
  def can_increase_quantity?(quantity_increased)
    quantity_increased > 0
  end

  def can_decrease_quantity?(quantity_decreased)
    quantity_decreased > quantity
  end

end
