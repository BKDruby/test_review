module Airbnb
  module Reviews
    class Parser < ApplicationService
      COLLECTION_PATH = %w[data presentation stayProductDetailPage reviews reviews]
      MAPPING = {
        external_uid: 'id',
        text: 'comments',
        external_created_at: 'createdAt',
        rating: 'rating',
        author_uid: ['reviewee', 'id'],
      }

      def initialize(response_json, default_values = {})
        @response_json = response_json
        @default_values = default_values
      end

      def call
        return [] unless reviews_colection.present?

        reviews_colection.map do |review|
          default_values.merge(map_review(review))
        end
      end

      private

      attr_reader :response_json, :default_values

      def reviews_colection
        @reviews_colection ||= response_json.dig(*COLLECTION_PATH)
      end

      def map_review(review)
        MAPPING.map do |key, value|
          [key, review.dig(*value)]
        end.to_h
      end
    end
  end
end