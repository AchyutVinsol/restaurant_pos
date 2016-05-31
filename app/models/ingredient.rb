class Ingredient < ActiveRecord::Base
  after_commit :create_inventory_items_of_ingredient

  has_many :inventory_items
  has_many :locations, through: :inventory_items

  private

    def create_inventory_items_of_ingredient
      #create an invetory item of ingredient for each location
      Location.all.find_each do |location|
        inventory_item = Inventory_item.new
        inventory_item.ingredient_id = id
        inventory_item.location_id = location.id
        inventory_item.quantity = 0
        inventory_item.save
      end
    end
end
