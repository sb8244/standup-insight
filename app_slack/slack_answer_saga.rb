class SlackAnswerSaga
  def initialize(slack_api, slack_user_mapping)
    @slack_api = slack_api
    @slack_user_mapping = slack_user_mapping
  end

  def process(text:, reply_proc:)
    reply_proc.call(text: "text #{text}!")
  end

  private

  attr_reader :slack_api, :slack_user_mapping
end
