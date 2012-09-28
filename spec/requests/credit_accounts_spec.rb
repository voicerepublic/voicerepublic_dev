require 'spec_helper'

describe "CreditAccounts" do
  describe "GET /credit_accounts" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get credit_accounts_path
      response.status.should be(200)
    end
  end
end
