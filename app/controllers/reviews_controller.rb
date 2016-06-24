class ReviewsController < ApplicationController
  before_action :set_meal

  def create
    # debugger
    # @review = @meal.reviews.build(review_params << user_id: current_user.id)
    @review = @meal.reviews.build(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to :back, notice: 'Succesfully posted your review!'
    else
      redirect_to :back, alert: "Failed to post review because: #{@review.errors.full_messages.join(', ')}"
    end
  end

  def index
    debugger
  end

  private

    def review_params
      params.permit(:comment, :rating)
    end

    def set_meal
      @meal = Meal.where(id: params[:meal_id]).take
    end

end
