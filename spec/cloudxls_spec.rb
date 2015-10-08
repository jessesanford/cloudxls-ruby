require 'spec_helper'

describe "CloudXLS" do
  describe "CloudXLS.api_key" do
    describe "From ENV" do
      before do
        ENV["CLOUDXLS_API_KEY"] = "ENV"
        load('lib/cloudxls.rb')
      end

      it "should automatically set" do
        expect(CloudXLS.api_key).to eq("ENV")
      end
    end

    describe "From User" do
      it "should allow manual set" do
        CloudXLS.api_key = "FOO"
        expect(CloudXLS.api_key).to eq("FOO")
        CloudXLS.api_key = "BAR"
        expect(CloudXLS.api_key).to eq("BAR")
      end
    end
  end

  describe "CloudXLS.api_secret" do
    describe "From Env" do
      before do
        ENV["CLOUDXLS_API_SECRET"] = "ENV"
        load('lib/cloudxls.rb')
      end

      it "should automatically set" do
        expect(CloudXLS.api_secret).to eq("ENV")
      end
    end

    describe "From User" do
      it "should allow manual set" do
        CloudXLS.api_secret = "FOO"
        expect(CloudXLS.api_secret).to eq("FOO")
        CloudXLS.api_secret = "BAR"
        expect(CloudXLS.api_secret).to eq("BAR")
      end
    end
  end

  describe "CloudXLS.api_host" do
    describe "From Env" do
      before do
        ENV["CLOUDXLS_API_HOST"] = "ENV"
        load('lib/cloudxls.rb')
      end

      it "should automatically set" do
        expect(CloudXLS.api_host).to eq("ENV")
      end
    end

    describe "Default" do
      before do
        ENV["CLOUDXLS_API_HOST"] = nil
        load('lib/cloudxls.rb')
      end

      it "has default value" do
        expect(CloudXLS.api_host).to eq("api.cloudxls.com")
      end
    end

    describe "From User" do
      it "should allow manual set" do
        CloudXLS.api_host = "FOO"
        expect(CloudXLS.api_host).to eq("FOO")
        CloudXLS.api_host = "BAR"
        expect(CloudXLS.api_host).to eq("BAR")
      end
    end
  end
end
