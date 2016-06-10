class AddDescriptionToMeals < ActiveRecord::Migration
  def change
    change_table(:meals) do |t|
      t.text :description
    end
  end
end
