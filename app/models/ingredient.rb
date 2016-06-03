# == Schema Information
#
# Table name: ingredients
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  price             :decimal(8, 2)
#  veg               :boolean          default(TRUE)
#  can_request_extra :boolean          default(FALSE)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_ingredients_on_name  (name)
#

class Ingredient < ActiveRecord::Base

  validates :price, :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, unless: 'price.blank?'

  has_many :inventory_items, dependent: :destroy
  has_many :locations, through: :inventory_items

  after_create :create_inventory_items

  private

    def create_inventory_items
      #create an invetory item of ingredient for each location
      Location.find_each do |location|
        inventory_item = location.inventory_items.new
        inventory_item.ingredient_id = id
        inventory_item.quantity = 0
        inventory_item.save!
      end
    end
end
