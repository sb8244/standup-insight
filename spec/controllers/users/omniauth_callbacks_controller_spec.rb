require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }

  before do
    user.groups << group
  end

  describe 'GET slack' do
    before do
      OmniAuth.config.add_mock(:slack, {
        credentials: {
          expires: false,
          token: 'cred_token'
        },
        info: {
          team: 'Team Name',
          team_id: 'team_id',
          user_id: 'user_id'
        },
        extra: {
          bot_info: {
            bot_access_token: 'bot_access_token',
            bot_user_id: 'bot_user_id'
          },
          raw_info: {
            url: 'http://url.com'
          }
        }
      })
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:slack]
    end

    it "requires a logged in user" do
      get :slack
      expect(response).to redirect_to(root_url)
      expect(flash[:error]).to eq(Users::OmniauthCallbacksController::SLACK_INTEGRATION_SIGN_IN)
    end

    it 'is successful' do
      sign_in(user)
      get :slack
      expect(response).to redirect_to(root_url)
      expect(flash[:success]).to eq(Users::OmniauthCallbacksController::SLACK_INTEGRATION_SUCCESS)
    end
  end
end
