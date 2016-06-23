# == Schema Information
#
# Table name: transactions
#
#  id          :integer          not null, primary key
#  captured    :boolean          default(TRUE)
#  amount      :decimal(8, 2)
#  order_id    :integer
#  last4       :string(255)      default("xxxx")
#  brand       :string(255)      default("Fake")
#  currency    :string(255)      default("usd")
#  card_id     :string(255)
#  charge_id   :string(255)
#  customer_id :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_transactions_on_card_id      (card_id)
#  index_transactions_on_charge_id    (charge_id)
#  index_transactions_on_customer_id  (customer_id)
#  index_transactions_on_order_id     (order_id)
#
# Foreign Keys
#
#  fk_rails_59d791a33f  (order_id => orders.id)
#

class Transaction < ActiveRecord::Base
  belongs_to :order

  def charge
    @charge || Stripe::Charge.retrieve(charge_id)
  end

  def refund
    @charge = charge
    if @charge[:amount] > @charge[:amount_refunded]
      Stripe::Refund.create(charge: @charge[:id])
    end
  end

end
