class ListingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @listings = current_user.listings
  end

  def new
    @listing = Listing.new
  end

  def create
    @listing = current_user.listings.build(listing_params)
    if @listing.save
      CollectReviewsJob.perform_later(@listing.id)

      redirect_to root_path, notice: "URL saved"
    else
      render :new
    end
  end

  private

  def listing_params
    params.require(:listing).permit(:url)
  end
end
