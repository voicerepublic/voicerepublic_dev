require 'rails_helper'

describe "Participations" do
  describe "create and destroy" do
    before do
      @talk = FactoryGirl.create(:talk)
      @user = FactoryGirl.create(:user)
      login_user @user
    end
    it "creates a participation from Series", js: true do
      expect {
        visit series_path(@talk.series)
        find('.qa-subscribe').click
      }.to change(Participation, :count).by(1)
    end
    it "deletes a participation from Series", js: true do
      FactoryGirl.create(:participation, series: @talk.series, user: @user)
      expect {
        visit series_path(@talk.series)
        find('.qa-unsubscribe').click
      }.to change(Participation, :count).by(-1)
      expect(current_path).to eq(series_path(@talk.series))
    end
  end
end
