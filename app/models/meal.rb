# == Schema Information
#
# Table name: meals
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  price              :decimal(8, 2)
#  image_file_name    :string(255)
#  image_content_type :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_meals_on_name  (name)
#

class Meal < ActiveRecord::Base
  has_many :recipe_items, dependent: :destroy
  has_many :ingredients, through: :recipe_items
  accepts_nested_attributes_for :tasks, allow_destroy: true

  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }#, default_url: "/images/:style/missing.png"
  validates_attachment :image, presence: true#, content_type: { content_type: ["image/jpeg", "image/gif", "image/png"] }, size: { in: 0..10.kilobytes }
end
