require "rails_helper"

RSpec.describe SlackSessionKickoffJob do
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_mapping) { user.slack_user_mappings.create!(group: group, slack_user_id: SecureRandom.hex(3), slack_team_id: SecureRandom.hex(3)) }
  let!(:stand_up) { group.todays_standup }
  let!(:old_stand_up) { group.send(:find_or_create_standup_for_day!, -1) }
  let!(:slack_integration) { FactoryGirl.create(:slack_integration, user: user, group: group) }

  before { user.groups << group }

  subject(:job) { SlackSessionKickoffJob.perform_now(user_mapping, stand_up) }

  context "with an existing slack session for another standup" do
    let!(:session) { user_mapping.slack_answer_sessions.create!(status: "active", current_question_id: 1, stand_up: old_stand_up) }

    it "cancels the old session" do
      expect { job }.to change { session.reload.status }.from("active").to("cancelled")
    end

    it "creates a new session" do
      expect { job }.to change { SlackAnswerSession.count }.by(1)
    end
  end

  context "with an existing slack session for the today's standup" do
    let!(:session) { user_mapping.slack_answer_sessions.create!(status: "active", current_question_id: 1, stand_up: stand_up) }

    it "does nothing" do
      expect {
        expect {
          job
        }.not_to change { session.reload }
      }.not_to change { SlackAnswerSession.count }
    end
  end

  it "creates a new session" do
    expect { job }.to change { SlackAnswerSession.count }.by(1)
    expect(SlackAnswerSession.last.attributes.symbolize_keys).to include(
      status: "active",
      current_question_id: stand_up.question_set.first_id
    )
  end

  it "kicks off a slack message" do
    key = "slack_bot_server:queue"
    $redis.llen(key).times { $redis.lpop(key) }

    expect {
      job
    }.to change { $redis.llen(key) }.from(0).to(1)

    expect(JSON.parse($redis.lpop(key))).to eq([
      "say_to",
      slack_integration.bot_token,
      user_mapping.slack_user_id,
      { "text" => "Time for your standup! #{stand_up.question_set.first}" }
    ])
  end
end
