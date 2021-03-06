class ShiftValidator < ActiveModel::Validator
  def validate(record)
    if record.closing_time < MINIMUM_SHIFT_HOURS.hours.since(record.opening_time)
      record.errors[:opening_time] << " should be earlier than closing time by #{ MINIMUM_SHIFT_HOURS } hours or more!"
    end
  end
end
