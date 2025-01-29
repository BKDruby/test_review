class ReviewsDailyUpdaterJob < ApplicationJob
  queue_as :default

  def perform
    Listing.all.find_each do |listing|
      listing.in_progress!
      CollectReviewsJob.perform_later(listing.id)
    end
  end
end
