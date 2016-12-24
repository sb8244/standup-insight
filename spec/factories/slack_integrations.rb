FactoryGirl.define do
  factory :slack_integration do
    bot_token { SecureRandom.hex(6) }
    bot_user_id { SecureRandom.hex(3) }
    slack_team_name { SecureRandom.hex(6) }
    slack_team_id { SecureRandom.hex(6) }
    slack_team_url { Faker::Internet.url }
    slack_user_id { SecureRandom.hex(6) }
  end
end
