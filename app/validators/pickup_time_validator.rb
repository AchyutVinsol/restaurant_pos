class PickupTimeValidator < ActiveModel::Validator
  def validate(order)
    location = order.location
    #FIXME_DONE: move this condition in model. also not for pending for being paid
    pickup_time = order.pickup_time.to_s(:compareable)
    compareable_closing_time = location.closing_time.to_s(:compareable)
    compareable_opening_time = location.opening_time.to_s(:compareable)

    if !(pickup_time > compareable_opening_time && pickup_time < compareable_closing_time)
      order.errors[:pickup_time] << " should be between #{location.opening_time.to_s(:time)} and #{location.closing_time.to_s(:time)}!"
    end
  end
end
