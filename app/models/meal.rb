# == Schema Information
#
# Table name: meals
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  price              :decimal(8, 2)
#  active             :boolean          default(TRUE)
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

  validates :price, :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, unless: 'price.blank?'
  has_attached_file :image, styles: { medium: "300x300>", thumb: "100x100>" }#, default_url: "/images/:style/missing.png"
  validates_attachment_file_name :image, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/]
  validates_attachment :image, presence: true, content_type: { content_type: ["image/jpg", "image/jpeg", "image/png", "image/gif"] }#, size: { in: 0..10.kilobytes }

  has_many :recipe_items, dependent: :destroy
  has_many :ingredients, through: :recipe_items
  accepts_nested_attributes_for :recipe_items, allow_destroy: true

  validates_with PriceValidator

  scope :active_meals, -> { where(active: true) }

  def toogle_status
    if active
      deactivate
    else
      activate
    end
  end

  def activate
    self.active = true
    save
  end

  def deactivate
    self.active = false
    save
  end

  def minimum_price
    recipe_items.inject(0){ |sum, recipe| sum + (recipe.quantity * recipe.ingredient.price) }.to_f
  end
end
