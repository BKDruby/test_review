module Airbnb
  module Reviews
    class RequestCatcher < ApplicationService
      def initialize(url:, url_request_pattern:)
        @url = url
        @url_request_pattern = url_request_pattern
      end

      def call
        network.on(:request_will_be_sent) do |params|
          if params["request"]["url"].include?(url_request_pattern)
            @request = params["request"]
          end
        end

        web_driver.navigate.to(url)
        sleep 1 until @request.present?

        @request
      ensure
        web_driver.quit if web_driver
      end


      private

      attr_reader :url, :url_request_pattern

      def selenium_options
        Selenium::WebDriver::Chrome::Options.new.tap do |options|
          options.add_argument("--headless")
          options.add_argument("--disable-gpu")
          options.add_argument("--disable-extensions")
          options.add_argument("--no-sandbox")
          options.add_argument("--disable-dev-shm-usage")
        end
      end

      def web_driver
        @web_driver ||= Selenium::WebDriver.for :chrome, options: selenium_options
      end

      def network
        @network ||= web_driver.devtools.network.tap { |network| network.enable }
      end
    end
  end
end