# == Schema Information
#
# Table name: line_items
#
#  id         :integer          not null, primary key
#  price      :decimal(8, 2)
#  meal_id    :integer
#  order_id   :integer
#  quantity   :decimal(10, )
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_line_items_on_meal_id   (meal_id)
#  index_line_items_on_order_id  (order_id)
#
# Foreign Keys
#
#  fk_rails_2dc2e5c22c  (order_id => orders.id)
#  fk_rails_dc2631faef  (meal_id => meals.id)
#

class LineItem < ActiveRecord::Base
  belongs_to :meal
  belongs_to :order
  has_many :extra_items
end
