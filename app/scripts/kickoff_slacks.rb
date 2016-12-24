threads = SlackUserMapping.find_each.map do |user_mapping|
  stand_up = user_mapping.group.todays_standup
  Thread.new { SlackSessionKickoffJob.perform_now(user_mapping, stand_up) }
end

threads.map(&:join)
