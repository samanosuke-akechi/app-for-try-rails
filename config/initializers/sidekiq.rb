Sidekiq.configure_server do |config|
  # config.redis = { url: "redis://#{ENV.fetch('REDIS_SERVER')}" }
  config.redis = { url: ENV.fetch('REDIS_SERVER', 'redis://redis:6379') }
end

Sidekiq.configure_client do |config|
  # config.redis = { url: "redis://#{ENV.fetch('REDIS_SERVER')}" }
  config.redis = { url: ENV.fetch('REDIS_SERVER', 'redis://redis:6379') }
end
