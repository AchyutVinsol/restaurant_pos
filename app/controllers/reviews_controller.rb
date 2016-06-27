class ReviewsController < ApplicationController
  #FIXME_DONE: who can login
  before_action :set_meal, :ensure_logged_in

  def create
    # @review = @meal.reviews.build(review_params << user_id: current_user.id)
    @review = @meal.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to :back, notice: 'Succesfully posted your review!'
    else
      redirect_to :back, alert: "Failed to post review because: #{@review.errors.full_messages.join(', ')}"
    end
  end

  private

    def review_params
      params.permit(:comment, :rating)
    end

    def set_meal
      @meal = Meal.where(id: params[:meal_id]).take
      #FIXME_DONE: what if meal not founc
      if @meal.nil?
        redirect_to :back, alert: "Meal not found in params:#{params}!"
      end
    end

end
