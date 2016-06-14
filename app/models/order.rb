# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  status     :integer          default(0)
#  price      :decimal(8, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_f868b47f6a  (user_id => users.id)
#

class Order < ActiveRecord::Base
  belongs_to :user

  #FIXME_DONE: dependent?
  has_many :line_items, dependent: :destroy
  has_many :meals, through: :line_items

  before_save :set_price

  enum status: [ :pending, :placed, :paid, :delivered ]

  private

  #FIXME_DONE: needed set_price for order before save
    def set_price
      total = 0
      line_items.each do |line_item|
        total_extra = line_item.extra_items.inject(0) { |sum, extra_item| sum + extra_item.price }
        total += ((line_item.price + total_extra) * line_item.quantity)
      end
      self.price = total
    end

end
