require_relative 'slack_answer_saga'

class SteveBot < SlackBotServer::Bot
  on_im do |data|
    slack_user_mapping = SlackUserMapping.find_by(slack_user_id: data.fetch("user"), slack_team_id: data.fetch("team"))

    if data['message'] == 'who are you'
      reply text: "I am #{bot_user_name} (user id: #{bot_user_id}, connected to team #{team_name} with team id #{team_id}"
    elsif data['message'] == 'counts'
      reply text: "#{User.count}"
    elsif slack_user_mapping
      slack_api = slack_user_mapping.group.slack_integration.slack_api
      SlackAnswerSaga.new(slack_api, slack_user_mapping).process(text: data.fetch("message"), reply_proc: method(:reply))
    else
      reply text: "Sorry, I don't know who you are."
    end
  end
end

queue = SlackBotServer::RedisQueue.new(redis: $redis)
server = SlackBotServer::Server.new(queue: queue)

server.on_add do |token|
  puts "Starting #{token}"
  SteveBot.new(token: token)
end

SlackIntegration.find_each do |integration|
  server.add_bot(integration.bot_token)
end

server.start
