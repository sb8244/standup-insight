require 'rails_helper'

RSpec.describe GroupsController, type: :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:group2) { FactoryGirl.create(:group) }

  before do
    user.groups << group
    sign_in(user)
  end

  render_views

  describe "GET index" do
    it "requires the user to be logged in" do
      sign_out(user)
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end

    it "renders all of the users groups" do
      get :index
      expect(response.status).to eq(200)
      expect(response.body).to include(group.title)
      expect(response.body).not_to include(group2.title)
    end
  end

  describe "GET show" do
    it "shows 'Submit Standup' form for today's standup" do
      get :show, params: { id: group.id }
      expect(response.body).to include(answers_path(stand_up_id: group.todays_standup.id))
      expect(response.body).not_to include(answers_path(stand_up_id: group.tomorrows_standup.id))
    end

    it "shows 'Submit Standup' form for tomorrow's standup" do
      get :show, params: { id: group.id, when: "tomorrow" }
      expect(response.body).to include(answers_path(stand_up_id: group.tomorrows_standup.id))
      expect(response.body).not_to include(answers_path(stand_up_id: group.todays_standup.id))
    end

    context "with today and tomorrow's standup completed" do
      let!(:today_answer) { group.todays_standup.answers.create!(user: user, question_id: 1, content: "Test answer", question_content: "A test question") }
      let!(:tomorrows_answer) { group.tomorrows_standup.answers.create!(user: user, question_id: 1, content: "Another Answer", question_content: "B question") }

      it "doesn't show today 'Submit Standup' form" do
        get :show, params: { id: group.id }
        expect(response.body).not_to include(answers_path(stand_up_id: group.todays_standup.id))
        expect(response.body).not_to include(answers_path(stand_up_id: group.tomorrows_standup.id))
      end

      it "shows today's answers" do
        get :show, params: { id: group.id }
        expect(response.body).to include("Test answer")
        expect(response.body).to include("A test question")
      end

      it "doesn't show tomorrow 'Submit Standup' form" do
        get :show, params: { id: group.id, when: "tomorrow" }
        expect(response.body).not_to include(answers_path(stand_up_id: group.todays_standup.id))
        expect(response.body).not_to include(answers_path(stand_up_id: group.tomorrows_standup.id))
      end

      it "shows tomorrows's answers" do
        get :show, params: { id: group.id, when: "tomorrow" }
        expect(response.body).to include("Another Answer")
        expect(response.body).to include("B question")
      end
    end
  end
end
