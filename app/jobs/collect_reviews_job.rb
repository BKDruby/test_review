class CollectReviewsJob < ApplicationJob
  queue_as :default

  def perform(listing_id)
    listing = Listing.find(listing_id)

    Airbnb::Reviews::Scraper.call(url: listing.url, listing_id:)
    listing.ready!
  end
end
