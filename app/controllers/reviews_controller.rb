class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_listing

  def index
    @reviews = @listing.reviews
  end

  def show
    @review = Review.find(params[:id])
  end

  private

  def set_listing
    @listing = Listing.find(params[:listing_id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
