class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.string :comment
      t.integer :rating
      t.references :user, index: true
      t.references :reviewable, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
