# frozen_string_literal: true

sidekiq_config = {
  url: ENV["REDIS_URL"],
  id: nil,
  timeout: 3
}

Sidekiq.configure_server do |config|
  config.redis = sidekiq_config
end

Sidekiq.configure_client do |config|
  config.redis = sidekiq_config
end
