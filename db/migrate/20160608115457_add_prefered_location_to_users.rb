class AddPreferedLocationToUsers < ActiveRecord::Migration
  def change
    add_column(:users, :prefered_location, :string, index: true)
  end
end
