class AddStripeUserIdToUser < ActiveRecord::Migration
  def change
    change_table(:users) do |t|
      t.string :stripe_user_id
    end
  end
end
