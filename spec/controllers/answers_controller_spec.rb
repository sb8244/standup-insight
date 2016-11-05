require 'rails_helper'

RSpec.describe AnswersController, :type => :controller do
  let!(:user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }

  before do
    user.groups << group
    sign_in(user)
  end

  describe "POST create" do
    it "requires all questions to be answered" do
      expect {
        post :create, params: { answers: { 1 => "Test", 2 => "Test", 3 => "" }, stand_up_id: group.todays_standup.id }
        expect(response).to redirect_to(group_path(group))
        expect(flash[:standup_form_error]).to eq("All questions must be answered.")
      }.not_to change { Answer.count }
    end

    it "doesn't let a user double submit" do
      user.answers.create!(stand_up: group.todays_standup, question_id: 1, content: "Test", question_content: "Who are you?")
      expect {
        post :create, params: { answers: { 1 => "Test 1", 2 => "Test 2", 3 => "Test 3" }, stand_up_id: group.todays_standup.id }
        expect(response).to redirect_to(group_path(group))
        expect(flash[:standup_form_error]).to eq("This standup has already been submitted.")
      }.not_to change { Answer.count }
    end

    it "creates an Answer for each answer" do
      expect {
        post :create, params: { answers: { 1 => "Test 1", 2 => "Test 2", 3 => "Test 3" }, stand_up_id: group.todays_standup.id }
        expect(response).to redirect_to(group_path(group))
        expect(flash[:standup_form_success]).to eq("Thanks for your standup!")
      }.to change { Answer.count }.by(3)

      expect(Answer.pluck(:user_id, :stand_up_id).uniq).to eq([[user.id, group.todays_standup.id]])
    end
  end
end
