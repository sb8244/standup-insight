require "rails_helper"

RSpec.describe SlackAnswerSaga do
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user) { FactoryGirl.create(:user) }
  let!(:user_mapping) { user.slack_user_mappings.create!(group: group, slack_user_id: "123", slack_team_id: "456") }
  let!(:stand_up) { group.todays_standup }

  before { user.groups << group }

  subject { SlackAnswerSaga.new(user_mapping) }

  let!(:reply_proc) do
    Class.new do
      attr_reader :texts

      def initialize
        @texts = []
      end

      def call(text: nil)
        @texts << text
      end
    end.new
  end

  context "when a session hasn't been started" do
    it "replies that there isn't an active session" do
      subject.process(text: "Hi!", reply_proc: reply_proc)
      expect(reply_proc.texts).to eq(["I don't seem to be taking a standup from you right now!"])
    end
  end

  context "when a session is present but none active" do
    let!(:session) { user_mapping.slack_answer_sessions.create!(status: "complete", current_question_id: 3, stand_up: stand_up) }

    it "replies that there isn't an active session" do
      subject.process(text: "Hi!", reply_proc: reply_proc)
      expect(reply_proc.texts).to eq(["I don't seem to be taking a standup from you right now!"])
    end
  end

  context "when a session has been started" do
    let(:current_question) { 1 }
    let!(:session) { user_mapping.slack_answer_sessions.create!(status: "active", current_question_id: current_question, stand_up: stand_up) }

    context "when the current question = 1" do
      it "logs the answer" do
        expect {
          subject.process(text: "Test", reply_proc: reply_proc)
        }.to change { session.slack_responses.count }.by(1)

        expect(session.slack_responses.last.attributes.symbolize_keys).to include(
          text: "Test",
          question_id: 1,
          question_content: group.question_set.question(1)
        )
      end

      it "replies to continue answering or 'next'" do
        subject.process(text: "Test", reply_proc: reply_proc)
        expect(reply_proc.texts).to eq(["Thanks! Continue answering this question or type 'next' to continue."])
      end

      it "handles 'next' by advancing the question id in the session" do
        expect {
          expect {
            subject.process(text: "NeXt", reply_proc: reply_proc)
          }.not_to change { session.slack_responses.count }
        }.to change { session.reload.current_question_id }.from(1).to(2)

        expect(reply_proc.texts).to eq(["Thanks! #{group.question_set.question(2)}"])
      end
    end

    context "when the current question isn't the first or last" do
      let(:current_question) { 2 }

      it "replies to continue answering or 'next'" do
        expect {
          subject.process(text: "Test", reply_proc: reply_proc)
          expect(reply_proc.texts).to eq(["Thanks! Continue answering this question or type 'next' to continue."])
        }.to change { session.slack_responses.count }.by(1)
      end
    end

    context "when the current question is the last question" do
      let(:current_question) { 3 }

      it "logs the answer" do
        expect {
          subject.process(text: "Test", reply_proc: reply_proc)
        }.to change { session.slack_responses.count }.by(1)
      end

      it "replies to continue answering or 'finish'" do
        subject.process(text: "Test", reply_proc: reply_proc)
        expect(reply_proc.texts).to eq(["Thanks! Continue answering this question or type 'finish' to complete your standup."])
      end

      describe "finishing" do
        context "with all answers present" do
          let!(:response1) { session.slack_responses.create!(text: "First", question_id: 1, question_content: group.question_set.question(1)) }
          let!(:response2) { session.slack_responses.create!(text: "First Part 2", question_id: 1, question_content: group.question_set.question(1)) }
          let!(:response3) { session.slack_responses.create!(text: "Second", question_id: 2, question_content: group.question_set.question(2)) }
          let!(:response4) { session.slack_responses.create!(text: "Last", question_id: 3, question_content: group.question_set.question(3)) }

          it "logs all answers" do
            expect {
              subject.process(text: "FinIsh", reply_proc: reply_proc)
            }.to change { Answer.count }.by(3)
          end

          it "combines answers for the same question" do
            subject.process(text: "FinIsh", reply_proc: reply_proc)
            expect(Answer.first.content).to eq("First\n\nFirst Part 2")
          end

          it "completes the slack session" do
            expect {
              expect {
                expect {
                  subject.process(text: "FinIsh", reply_proc: reply_proc)
                }.not_to change { session.slack_responses.count }
              }.not_to change { session.reload.current_question_id }.from(3)
            }.to change { session.status }.from("active").to("complete")

            expect(reply_proc.texts).to eq(["Thanks! Your standup for #{stand_up.date_of_standup} is complete."])
          end
        end

        context "without all answers present" do
          let!(:response1) { session.slack_responses.create!(text: "First", question_id: 1, question_content: group.question_set.question(1)) }

          it "completes session" do
            expect {
              subject.process(text: "FinIsh", reply_proc: reply_proc)
            }.to change { session.reload.status }.from("active").to("complete")
          end

          it "logs what answers it has" do
            expect {
              subject.process(text: "FinIsh", reply_proc: reply_proc)
            }.to change { Answer.count }.by(1)
          end
        end
      end
    end
  end
end
