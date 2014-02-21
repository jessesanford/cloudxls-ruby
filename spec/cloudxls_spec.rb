require 'spec_helper'

describe "CloudXLS" do
  before do

  end

  describe "CloudXLS.api_key" do
    it "should not register api_key" do
      CloudXLS.api_key = "FOO"
      expect( CloudXLS.api_key ).to eq("FOO")
    end

    it "should not register api_key" do
      CloudXLS.api_key = "FOO"
      CloudXLS.api_key = "BAR"
      expect( CloudXLS.api_key ).to eq("BAR")
    end
  end
end