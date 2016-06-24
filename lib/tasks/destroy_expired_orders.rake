namespace :admin do
  desc 'Destroy all expired orders to recliam ingredients occupied in meal.'
  task recliam_ingredients: :environment do
    #FIXME_DONE: Order.expired.find_each
    Order.find_each do |order|
      if order.expired?
        order.destroy
      end
    end
  end
end
