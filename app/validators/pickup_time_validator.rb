class PickupTimeValidator < ActiveModel::Validator
  def validate(order)
    location = order.location
    # debugger
    if order.status != 'pending'
      #FIXME_DONE: use time.to_s()
      pickup_time = order.pickup_time.to_s(:compareable)
      compareable_closing_time = location.closing_time.to_s(:compareable)
      compareable_opening_time = location.opening_time.to_s(:compareable)
      if pickup_time < compareable_closing_time && pickup_time > compareable_opening_time
        order.errors[:pickup_time] << " should be between #{location.opening_time} and #{location.closing_time}!"
      end
    end
  end
end
