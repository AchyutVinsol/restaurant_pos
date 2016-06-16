# == Schema Information
#
# Table name: extra_items
#
#  id            :integer          not null, primary key
#  line_item_id  :integer
#  ingredient_id :integer
#  price         :decimal(8, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_extra_items_on_ingredient_id  (ingredient_id)
#  index_extra_items_on_line_item_id   (line_item_id)
#
# Foreign Keys
#
#  fk_rails_9e60639b24  (line_item_id => line_items.id)
#  fk_rails_9e662c3640  (ingredient_id => ingredients.id)
#

class ExtraItem < ActiveRecord::Base

  belongs_to :line_items
  belongs_to :ingredient

  before_save :set_price

  private

    def set_price
      self.price = ingredient.price
    end

end
