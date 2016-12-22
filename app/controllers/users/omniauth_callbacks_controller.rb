class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  SLACK_INTEGRATION_SUCCESS = "Slack Integration setup!"
  SLACK_INTEGRATION_SIGN_IN = "Must be signed in before setting up slack"

  def slack
    if current_user
      find_or_create_slack_integration!
      flash[:success] = SLACK_INTEGRATION_SUCCESS
      redirect_to root_url
    else
      flash[:error] = SLACK_INTEGRATION_SIGN_IN
      redirect_to root_url
    end
  end

  private

  def auth_info
    request.env["omniauth.auth"]
  end

  def find_or_create_slack_integration!
    current_user.slack_integrations.where(slack_team_id: auth_info[:info][:team_id]).first_or_initialize.tap do |integration|
      integration.group = current_user.groups.first
      integration.bot_token = auth_info[:extra][:bot_info][:bot_access_token]
      integration.bot_user_id = auth_info[:extra][:bot_info][:bot_user_id]
      integration.slack_team_name = auth_info[:info][:team]
      integration.slack_team_url = auth_info[:extra][:raw_info][:url]
      integration.slack_user_id = auth_info[:info][:user_id]
      integration.save! if integration.changed?
    end
  end
end
