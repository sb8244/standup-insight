require 'slack_bot_server/remote_control'

class SlackSessionKickoffJob < ApplicationJob
  queue_as :default

  attr_reader :slack_user_mapping, :stand_up

  def perform(slack_user_mapping, stand_up)
    @slack_user_mapping = slack_user_mapping
    @stand_up = stand_up

    return if active_session && active_session.stand_up == stand_up
    clear_old_session! if active_session && active_session.stand_up != stand_up
    create_new_session!
    private_message_slack!
  end

  private

  def active_session
    @active_session ||= slack_user_mapping.active_session
  end

  def clear_old_session!
    active_session.update!(status: "cancelled")
  end

  def create_new_session!
    slack_user_mapping.slack_answer_sessions.create!(status: "active", current_question_id: stand_up.question_set.first_id, stand_up: stand_up)
  end

  def private_message_slack!
    slack_control.say_to(bot_token, slack_user_mapping.slack_user_id, text: "Time for your standup! #{stand_up.question_set.first}")
  end

  def bot_token
    slack_user_mapping.group.slack_integration.bot_token
  end

  def slack_control
    @slack_control ||= begin
      queue = SlackBotServer::RedisQueue.new(redis: $redis)
      SlackBotServer::RemoteControl.new(queue: queue)
    end
  end
end
