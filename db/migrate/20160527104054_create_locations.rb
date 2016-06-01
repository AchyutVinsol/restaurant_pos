class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :name, unique: true, index: true
      t.string :state
      t.string :city
      t.string :street_first
      t.string :street_second
      t.boolean :default_location, default: false
      t.timestamp :opening_time
      t.timestamp :closing_time
      t.timestamps null: false
    end
  end
end
