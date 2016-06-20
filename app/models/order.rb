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
#  contact_number :string(255)      default("99999")
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
  #FIXME_DONE: dependent restrict
  has_many :transactions, dependent: :restrict_with_error

  #FIXME_AB: expiry shoudl be set when first item is set
  #FIXME_AB: one rake task to delete all expired order
  #FIXME_AB: one validation that expired orders can not be checkout/ current_order overweriet
  before_save :set_price, :set_expiry_at, if: :being_paid?
  before_save :set_price, if: :pending?
  after_save :block_inventories, :send_order_placed_mail, if: :being_paid?
  after_destroy :unblock_inventory#, if: :being_paid?

  scope :pending, -> { where(status: :pending) }

  #FIXME_AB: use hash
  enum status: {pending: 0, paid: 1, delivered: 2}

  validates :contact_number, presence: true, unless: 'pending?'
  validates :contact_number, numericality: { greater_than_or_equal_to: 1000000000 }, unless: 'pending?'
  validates_with PickupTimeValidator
  validates_with OrderIngredientsQuantityValidator

  # validates_with AvaliableMealValidator
  #FIXME_DONE: add a field placed_at and set it with a callback when order is placed

  def pending?
    self.status == 'pending'
  end

  def price_in_cents
    (price * 100).to_i
  end

  def mark_paid(charge, params)
    pickup_time = params[:order]
    transactions.build(charge_params(charge))
    self.status = 'paid'
    self.placed_at = Time.current
    self.pickup_time = Time.new(1, 1, 1, pickup_time[:'pickup_time(4i)'].to_i, pickup_time[:'pickup_time(5i)'].to_i, 0)
    self.contact_number = params[:contact_number]
    save
  end

  private

    def unblock_inventory
      line_items.each do |li|
        li.block_inventories(location.inventory_items)
      end
    end


    def block_inventories
      line_items.each do |li|
        li.block_inventories(location.inventory_items)
      end
    end

    # def unblock_inventory
    #   #FIXME_DONE: just do this. line_items.each{|li| li.unblock_inventory}
    #   @inventory_items = location.inventory_items
    #   line_items.each do |li|
    #     li.meal.recipe_items.each do |ri|
    #       quantity = 0
    #       if extra_items.any? { |ei| ei.ingredient_id == ri.ingredient_id }
    #         quantity = ri.quantity + 1
    #       else
    #         quantity = ri.quantity
    #       end
    #       @inventory_items.where(ingredient_id: ri.ingredient_id).take.increase_quantity(quantity * self.quantity)
    #     end
    #   end
    # end

    def being_paid?
      status_was == 'pending' && status == 'paid'
    end

    def send_order_placed_mail
      UserNotifier.order_placed_email(self).deliver_now
    end

    def charge_params(charge)
      {
        charge_id: charge.id,
        amount: charge.amount,
        currency: charge.currency,
        brand: charge[:source].brand,
        card_id: charge[:source].id,
        customer_id: charge[:source].customer,
        last4: charge[:source].last4
      }
    end

    def set_price
      # total = 0
      # FIXME_DONE: do something like line_item.sum{|li| li.total}
      # line_items.each do |li|
      #   total += (li.total * li.quantity)
      # end
      self.price = line_items.to_a.sum{ |li| li.total * li.quantity }
    end

    def set_expiry_at
      self.expiry_at = Time.current + MEAL_VALIDITY_MINUTES.minutes
    end

end
