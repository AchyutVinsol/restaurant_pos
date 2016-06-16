namespace :admin do
  desc 'Destroy all expired orders to recliam ingredients occupied in meal.'
  task recliam_ingredients: :environment do
    Order.all.each do |order|
      if order.expiry_at < Time.current
        order.destroy
      end
    end
  end
end
