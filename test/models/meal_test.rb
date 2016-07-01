require 'test_helper'

class MealTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "valid meal should be saved" do
    meal = meals(:valid_meal)
    meal.name = 'sample_3'
    assert meal.save
  end

  test "should not save meal without name" do
    meal = meals(:valid_meal)
    meal.name = '  '
    assert_not meal.save
  end

  test "should not save meal with same name" do
    meal = meals(:valid_meal1)
    meal.name = 'Sample_1'
    assert_not meal.save
  end

  test "should not save meal with same name ignoring capitals" do
    meal = meals(:valid_meal1)
    meal.name = 'sample_1'
    assert_not meal.save
  end

  test "should not save meal without price" do
    meal = meals(:valid_meal)
    meal.price = nil
    assert_not meal.save
  end

  test "should not save meal with zero price" do
    meal = meals(:valid_meal)
    meal.price = 0.0
    assert_not meal.save
  end

  test "should not save meal string price" do
    meal = meals(:valid_meal)
    meal.price = 'asd'
    assert_not meal.save
  end

  test "should not save meal with invalid attachment type" do
    meal = meals(:valid_meal)
    meal.image_content_type = 'image/abc'
    assert_not meal.save
  end

  test "should not save meal with invalid extension type" do
    meal = meals(:valid_meal)
    meal.image_file_name = 'image.abc'
    assert_not meal.save
  end

  # has_many :recipe_items, dependent: :destroy
  test "check recipe_items association" do
    meal = meals(:valid_meal)
    association = meal.association(:recipe_items)
    options = { dependent: :destroy, autosave: true }
    assert_equal(association.options, options, "incorrect association options")
 end

  # has_many :ingredients, through: :recipe_items
  test "check ingredients association" do
    meal = meals(:valid_meal)
    association = meal.association(:recipe_items)
    options = { :dependent=>:destroy, :autosave=>true }
    assert_equal(association.options, options, "incorrect association options")
 end

  # has_many :line_items
  test "check line_items association" do
    meal = meals(:valid_meal)
    association = meal.association(:line_items)
    options = { }
    assert_equal(association.options, options, "incorrect association options")
 end

  # has_many :reviews, as: :reviewable
  test "check reviews association" do
    meal = meals(:valid_meal)
    association = meal.association(:reviews)
    options = { as: :reviewable }
    assert_equal(association.options, options, "incorrect association options")
 end

  test "check function activate" do
    meal = meals(:valid_meal)
    meal.activate
    assert_equal(true, meal.active, "activate function fail")
  end

  test "check function toogle_status" do
    meal = meals(:valid_meal)
    status = meals(:valid_meal).active
    meal.toogle_status
    assert_equal(meal.active, !status, "toogle_status function fail")
  end

  test "check function toogle_status alternate" do
    meal = meals(:valid_meal)
    status = meals(:valid_meal).active
    meal.toogle_status
    meal.toogle_status
    assert_equal(meal.active, status, "toogle_status function fail")
  end

  test "check function deactivate" do
    meal = meals(:valid_meal)
    meal.deactivate
    assert_equal(false, meal.active, "activate function fail")
  end

  test "check function veg?" do
    meal = meals(:valid_meal)
    assert_equal(false, meal.veg?, "activate function fail")
  end

  test "check function minimum_price" do
    meal = meals(:valid_meal)
    meal.minimum_price
    assert_equal(meal.minimum_price, 9.5, "minimum_price function fail")
  end

  test "check function quantity_available_by_location" do
    meal = meals(:valid_meal)
    assert_equal(33, meal.quantity_available_by_location(locations(:sample_location)), "quantity_available_by_location function fail")
  end

  test "check function available?" do
    meal = meals(:valid_meal)
    assert_equal(true, meal.available?(locations(:sample_location)), "available? function fail")
  end

  test "check function reviewable?" do
    assert_equal(true, meals(:valid_meal).reviewable?(users(:sample_user)), "reviewable? function fail")
    assert_equal(false, meals(:valid_meal2).reviewable?(users(:sample_user)), "reviewable? function fail")
  end

  test "check function rating" do
    assert_equal(3, meals(:valid_meal).rating, "rating function fail")
    assert_equal(0, meals(:valid_meal2).rating, "rating function fail")
  end

end
