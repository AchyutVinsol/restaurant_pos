class ShiftValidator < ActiveModel::Validator
  def validate(record)
    shift = record.closing_time - record.opening_time
    #FIXME_AB: move shift time to constatns
    if shift < 6*60*60
      record.errors[:opening_time] << ' should be earlier than closing time by 6 hours or more!'
    end
  end
end
