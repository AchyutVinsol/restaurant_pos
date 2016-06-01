class Location < ActiveRecord::Base
  after_commit :create_inventory_items_of_location

  has_many :inventory_items, dependent: :destroy
  has_many :ingredients, through: :inventory_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :state, :city, :opening_time, :closing_time ,presence: true

  validates_with ShiftValidator

  private

    def create_inventory_items_of_location
      #create an invetory item of location for each ingredient
      Ingredient.all.find_each do |ingredient|
        inventory_item = InventoryItem.new
        inventory_item.ingredient_id = ingredient.id
        inventory_item.location_id = id
        inventory_item.quantity = 0
        inventory_item.save
      end
    end
end
