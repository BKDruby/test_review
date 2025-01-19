
module Airbnb
  module Reviews
    class Scraper < ApplicationService
      REVIEWS_URL_PATTERN = "StaysPdpReviewsQuery"

      def initialize(url:, listing_id:)
        @url = url
        @listing_id = listing_id
      end

      def call
        reviews_request = RequestCatcher.call(url:, url_request_pattern: REVIEWS_URL_PATTERN)

        Gatherer.call(reviews_request) do |reviews_response|
          Parser.call(reviews_response, listing_id:).tap { |reviews| Review.create!(reviews) }
        end
      end

      private

      attr_reader :url, :listing_id
    end
  end
end
