Devise.setup do |config|
  config.omniauth :slack, ENV.fetch('SLACK_API_KEY'), ENV.fetch('SLACK_API_SECRET'), scope: 'identify,bot'
end
