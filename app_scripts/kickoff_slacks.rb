now = Time.now.in_time_zone("US/Eastern")

if ENV["CHECK_INTERVAL"] && (now.wday == 6 || now.wday == 0) # don't run on weekends
  p "exiting"
  exit
end

threads = SlackUserMapping.find_each.map do |user_mapping|
  stand_up = user_mapping.group.todays_standup
  Thread.new { SlackSessionKickoffJob.perform_now(user_mapping, stand_up) }
end

threads.map(&:join)
