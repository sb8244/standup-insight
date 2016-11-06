require 'rails_helper'

RSpec.describe MeetingsController, :type => :controller do
  let!(:user) { FactoryGirl.create(:user, name: "Steve") }
  let!(:group_mate) { FactoryGirl.create(:user) }
  let!(:other_user) { FactoryGirl.create(:user) }
  let!(:group) { FactoryGirl.create(:group) }
  let!(:group2) { FactoryGirl.create(:group) }

  before do
    user.groups << group
    group_mate.groups << group
    other_user.groups << group2
    sign_in(user)
  end

  render_views

  describe "GET show" do
    it "redirects with order and cur set" do
      get :show, params: { id: group.id }
      view = controller.instance_variable_get(:@view)
      expect(response).to redirect_to(meeting_path(group, order: view.meeting_order.join(","), cur: view.current_order))
    end

    it "renders who's up" do
      get :show, params: { id: group.id, order: [user.id, group_mate.id].join(","), cur: user.id }
      expect(response.status).to eq(200)
      expect(response.body).to include("Steve's turn")
    end

    it "renders who's up" do
      get :show, params: { id: group.id, order: [user.id, group_mate.id].join(","), cur: group_mate.id }
      expect(response.status).to eq(200)
      expect(response.body).to include("#{group_mate.email}'s turn")
    end

    it "includes the current user's answers" do
      group.todays_standup.answers.create!(user: user, question_id: 1, content: "Test answer", question_content: "A test question")
      get :show, params: { id: group.id, order: [user.id, group_mate.id].join(","), cur: user.id }
      expect(response.body).to include("Test answer")
      expect(response.body).to include("A test question")
    end

    it "links to the next user" do
      order = [user.id, group_mate.id].join(",")
      get :show, params: { id: group.id, order: order, cur: user.id }
      expect(response.body).to include(CGI.escapeHTML(meeting_path(group, order: order, cur: group_mate.id)))
      expect(response.body).not_to include("Finish")
    end

    it "links to finish when on the last user" do
      get :show, params: { id: group.id, order: [user.id, group_mate.id].join(","), cur: group_mate.id }
      expect(response.body).to include("Finish")
    end
  end
end
