class SlackIntegration < ApplicationRecord
  belongs_to :user
  belongs_to :group

  def slack_api
    @slack_api = SlackApi.new(token: bot_token)
  end
end
