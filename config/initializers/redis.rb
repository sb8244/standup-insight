if Rails.env.test?
  $redis = MockRedis.new
else
  $redis = Redis.new
end
