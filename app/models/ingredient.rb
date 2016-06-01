class Ingredient < ActiveRecord::Base
  after_commit :create_inventory_items_of_ingredient

  has_many :inventory_items, dependent: :destroy
  has_many :locations, through: :inventory_items

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, unless: 'price.blank?',
    presence: true

  private

    def create_inventory_items_of_ingredient
      #create an invetory item of ingredient for each location
      Location.all.find_each do |location|
        inventory_item = InventoryItem.new
        inventory_item.ingredient_id = id
        inventory_item.location_id = location.id
        inventory_item.quantity = 0
        inventory_item.save
      end
    end
end
