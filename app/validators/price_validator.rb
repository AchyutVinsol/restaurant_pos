class PriceValidator < ActiveModel::Validator
  def validate(record)
    if record.price < record.minimum_price
      record.errors[:price] << " should be greater than cost of ingrdients #{ record.minimum_price }!"
    end
  end
end
