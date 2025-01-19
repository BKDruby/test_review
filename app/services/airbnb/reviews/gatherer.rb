module Airbnb
  module Reviews
    class Gatherer < ApplicationService
      LIMIT = 50

      def initialize(request)
        @request = request
      end

      def call
        offset = 0

        until yield(collect_reviews(limit: LIMIT, offset:)).blank?
          offset += LIMIT
        end
      end

      private

      attr_reader :request

      def collect_reviews(params)
        @request['url'] = update_url_parameters(@request['url'], params)
        execute_request(request)
      end

      def execute_request(request_info)
        uri = URI.parse(request_info['url'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')

        request_class = request_info['method'].capitalize
        request = Net::HTTP.const_get(request_class).new(uri.request_uri)

        request_info['headers']&.each do |key, value|
          request[key] = value
        end

        response = http.request(request)

        if response.is_a?(Net::HTTPSuccess)
          JSON.parse(response.body)
        else
          nil
        end
      end

      def update_url_parameters(url, params = {})
        uri = URI.parse(url)
        query = URI.decode_www_form(uri.query).to_h

        variables = JSON.parse(query['variables'])
        params.each do |key, value|
          variables['pdpReviewsRequest'][key.to_s] = value if variables['pdpReviewsRequest'].key?(key.to_s)
        end
        query['variables'] = variables.to_json

        uri.query = URI.encode_www_form(query)
        uri.to_s
      end
    end
  end
end