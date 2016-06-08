# == Schema Information
#
# Table name: locations
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  state            :string(255)
#  city             :string(255)
#  street_first     :string(255)
#  street_second    :string(255)
#  default_location :boolean          default(FALSE)
#  opening_time     :datetime
#  closing_time     :datetime
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_locations_on_name  (name)
#

class Location < ActiveRecord::Base

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :state, :city, :opening_time, :closing_time, presence: true

  has_many :inventory_items, dependent: :destroy
  has_many :ingredients, through: :inventory_items
  has_many :meals, -> { distinct }, through: :ingredients

  validates_with ShiftValidator

  scope :default, -> { where(default_location: true).take }

  after_create :create_inventory_items
  before_save :ensure_single_default

  def available_meals
    #FIXME_AB:  meals.active.select 
    meals.active_meals.select { |meal| available?(meal) }
  end

  private

    # def available?(meal)
    #   debugger
    #   # in i get all inventory_items, in a get recipe_items
    #   inv = meals.inventory_items
    #   rec = meals.recipe_items
    #   p inv
    #   p rec
    #   meals.all?{ |meal| i[k] > a[k] }
    # end

    def available?(meal)
      debugger
      meal.ingredients.first.inventory_items.length
      meal.ingredients.first.recipe_items.length
      #FIXME_AB: optimize
      meal.recipe_items.each do |recipe_item|
        inventory_item = inventory_items.where(id: recipe_item.ingredient_id).take
        if recipe_item.present? && recipe_item.quantity < inventory_item.quantity
          # debugger
          # return true
        end
      end
      return false
    end

    def available?
      
    end

    def ensure_single_default
      if default_location
        begin
          if Location.default
            current_default.default_location = false
            current_default.save
          end
        rescue ActiveRecord::RecordNotFound
          return false
        end
      end
    end

    def create_inventory_items
      #create an invetory item of location for each ingredient
      Ingredient.find_each do |ingredient|
        inventory_item = ingredient.inventory_items.new
        inventory_item.location_id = id
        inventory_item.quantity = 0
        inventory_item.save!
      end
    end
end
