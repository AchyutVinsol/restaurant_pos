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
    assert_equal(meal.active, true, "activate function fail")
  end

  test "check function deactivate" do
    meal = meals(:valid_meal)
    meal.deactivate
    assert_equal(meal.active, false, "activate function fail")
  end

  test "check function veg?" do
    meal = meals(:valid_meal)
    assert_equal(meal.veg?, true, "activate function fail")
  end

  test "check function minimum_price" do
    meal = meals(:valid_meal)
    meal.minimum_price
    assert_equal(meal.minimum_price, true, "incorrect association options")
  end

  test "check function quantity_available_by_location" do
    meal = meals(:valid_meal)
    association = meal.association(:reviews)
    options = { as: :reviewable }
    assert_equal(association.options, options, "incorrect association options")
  end

end
