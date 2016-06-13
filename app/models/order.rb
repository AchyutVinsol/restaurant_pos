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
  has_many :line_items
  has_many :meals, through: :line_items

  before_validation :set_price# also on adding a line item

  enum status: [ :pending, :placed, :paid, :delivered ]

  private

    def set_price
      self.price = meals.inject(0){|sum ,meal| sum += meal.price }
    end

end
