require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:group) { FactoryGirl.create(:group) }

  describe "todays_standup" do
    context "without an existing standup" do
      it "creates the correct standup" do
        expect {
          expect(group.todays_standup).to eq(StandUp.last)
          expect(group.todays_standup.date_of_standup).to eq(Date.current)
        }.to change { StandUp.count }.by(1)
      end
    end

    context "with an existing standup" do
      let!(:standup) { group.stand_ups.create!(date_of_standup: Date.current - 1) }
      let!(:todays_standup) { group.stand_ups.create!(date_of_standup: Date.current) }
      let!(:tomorrows_standup) { group.stand_ups.create!(date_of_standup: Date.current + 1) }

      it "returns the correct standup" do
        expect {
          expect(group.todays_standup).to eq(todays_standup)
        }.not_to change { StandUp.count }
      end
    end
  end

  describe "tomorrows_standup" do
    context "without an existing standup" do
      it "creates the correct standup" do
        expect {
          expect(group.tomorrows_standup).to eq(StandUp.last)
          expect(group.tomorrows_standup.date_of_standup).to eq(Date.current + 1)
        }.to change { StandUp.count }.by(1)
      end
    end

    context "with an existing standup" do
      let!(:standup) { group.stand_ups.create!(date_of_standup: Date.current - 1) }
      let!(:todays_standup) { group.stand_ups.create!(date_of_standup: Date.current) }
      let!(:tomorrows_standup) { group.stand_ups.create!(date_of_standup: Date.current + 1) }

      it "returns the correct standup" do
        expect {
          expect(group.tomorrows_standup).to eq(tomorrows_standup)
        }.not_to change { StandUp.count }
      end
    end
  end
end
