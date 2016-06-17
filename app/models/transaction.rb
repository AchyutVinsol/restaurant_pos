# == Schema Information
#
# Table name: transactions
#
#  id         :integer          not null, primary key
#  captured   :boolean          default(TRUE)
#  amount     :decimal(8, 2)
#  order_id   :integer
#  charge_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_transactions_on_charge_id  (charge_id)
#  index_transactions_on_order_id   (order_id)
#
# Foreign Keys
#
#  fk_rails_59d791a33f  (order_id => orders.id)
#

class Transaction < ActiveRecord::Base
  belongs_to :order

  def create(charge)
    
  end

end
