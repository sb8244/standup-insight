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
end
