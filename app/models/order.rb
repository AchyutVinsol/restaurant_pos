# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  location_id    :integer
#  expiry_at      :datetime
#  placed_at      :datetime
#  pickup_time    :datetime
#  status         :integer          default(0)
#  contact_number :integer          default(99999)
#  price          :decimal(8, 2)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_orders_on_location_id  (location_id)
#  index_orders_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_5b9551c291  (location_id => locations.id)
#  fk_rails_f868b47f6a  (user_id => users.id)
#

class Order < ActiveRecord::Base
  belongs_to :user

  belongs_to :location
  has_many :line_items, dependent: :destroy
  has_many :meals, through: :line_items

  before_save :set_price, :set_expiry_at
  after_destroy :reclaim
  # after_destroy :tester
  # before_save :set_placed_at, on: [:place]

  scope :pending, -> { where(status: :pending) }

  enum status: [ :pending, :paid, :delivered ]

  validates :contact_number, presence: true, unless: 'pending?'
  validates :contact_number, numericality: { greater_than_or_equal_to: 99999 }, unless: 'pending?'
  validates_with PickupTimeValidator

  # validates_with AvaliableMealValidator
  #FIXME_DONE: add a field placed_at and set it with a callback when order is placed

  def reclaim
    @inventory_items = location.inventory_items
    line_items.each do |li|
      li.meal.recipe_items.each do |ri|
        quantity = 0
        if extra_items.any? { |ei| ei.ingredient_id == ri.ingredient_id }
          quantity = ri.quantity + 1
        else
          quantity = ri.quantity
        end
        @inventory_items.where(ingredient_id: ri.ingredient_id).take.increase_quantity(quantity * self.quantity)
      end
    end
  end

  def pending?
    self.status == 'pending'
  end

  def pay(pickup_time, contact_number)
    # debugger
    self.status = 'paid'
    self.placed_at = Time.current
    # self.pickup_time = pickup_time
    # time1.utc.strftime( "%H%M%S" ) <= time2.utc.strftime( "%H%M%S" )
    self.pickup_time = Time.new(1, 1, 1, pickup_time[:'pickup_time(4i)'].to_i, pickup_time[:'pickup_time(5i)'].to_i, 0)
    self.contact_number = contact_number
    save
  end

  private

    def set_price
      total = 0
      # FIXME_DONE: do something like line_item.sum{|li| li.total}
      line_items.each do |li|
        total += (li.total * li.quantity)
      end
      self.price = total
    end

    def set_expiry_at
      self.expiry_at = Time.current + MEAL_VALIDITY_MINUTES.minutes
    end


  #FIXME_DONE: one meal can be added in cart only once
  #FIXME_DONE: inactive meal can not be added to cart
  #FIXME_DONE: soldout meal can not be added to cart
  #FIXME_DONE: order placement rules, timing, inventory
  #FIXME_DONE: callbacks inventory reduce

end
