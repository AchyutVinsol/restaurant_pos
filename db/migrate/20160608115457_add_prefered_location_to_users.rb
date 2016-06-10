class AddPreferedLocationToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.references :prefered_location, index: true, default: nil
    end
  end
end
