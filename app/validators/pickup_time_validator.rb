class PickupTimeValidator < ActiveModel::Validator
  def validate(order)
    location = order.location
    # debugger
    if order.status != 'pending'
      #FIXME_AB: use time.to_s()
      pickup_time = order.pickup_time.utc.strftime("%H%M%S%N")
      compareable_closing_time = location.closing_time.utc.strftime("%H%M%S%N")
      compareable_opening_time = location.opening_time.utc.strftime("%H%M%S%N")
      if pickup_time < compareable_closing_time && pickup_time > compareable_opening_time
        order.errors[:pickup_time] << " should be between #{location.opening_time} and #{location.closing_time}!"
      end
      # debugger
    end
  end
end
