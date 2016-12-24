require "rails_helper"

RSpec.describe SlackAnswerSaga do
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_mapping) { user.slack_user_mappings.create!(group: group, slack_user_id: "123", slack_team_id: "456") }

  before { user.groups << group }

  context "when a session hasn't been started" do
    it "replies that there isn't an active session"
  end

  context "when a session has been started" do
    context "when the current question = 1" do
      it "logs the answer"
      it "replies to continue answering or 'next'"
      it "handles 'next' by advancing the question id in the session"
    end

    context "when the current question isn't the first or last" do
      it "replies to continue answering or 'next'"
    end

    context "when the current question is the last question" do
      it "logs the answer"
      it "replies to continue answering or 'finish'"
      it "handles 'finish' by logging all answers and submitting the standup"
    end
  end
end
