class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.boolean :default_location, default: false
      t.timestamp :opening_time
      t.timestamp :closing_time
      t.timestamps null: false
    end
  end
end
