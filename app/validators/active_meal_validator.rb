class ActiveMealValidator < ActiveModel::Validator
  def validate(line_item)
    if !line_item.meal.active?
      line_item.errors[:active] << " should be activated by admin!"
    end
  end
end
