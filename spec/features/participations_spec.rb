require 'rails_helper'

describe "Participations" do
  describe "create and destroy" do
    before do
      @talk = FactoryGirl.create(:talk)
      @user = FactoryGirl.create(:user)
      login_user @user
    end
    # TODO: Participation used to be explicit. We need to rewrite it to be
    # implicit. When done, we should re-activate this spec.
    skip "creates a participation from Talk" do
      expect {
        visit talk_path(@talk)
        click_on "Participate"
      }.to change(Participation, :count).by(1)
    end
    it "creates a participation from Series" do
      expect {
        visit venue_path(@talk.venue)
        click_on "Subscribe to Series"
      }.to change(Participation, :count).by(1)
    end
    it "deletes a participation from Series" do
      FactoryGirl.create(:participation, venue: @talk.venue, user: @user)
      expect {
        visit venue_path(@talk.venue)
        click_on "Unsubscribe"
      }.to change(Participation, :count).by(-1)
      expect(current_path).to eq(venue_path(@talk.venue))
    end
  end
end
