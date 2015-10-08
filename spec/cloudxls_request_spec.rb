require 'spec_helper'

describe "CloudXLSRequest" do
  describe "#config" do
    it "hash and hash json are equivalent" do
      config_hash = {key1: "value", key2: "value"}
      hash_req = CloudXLS.new_request
      json_req = CloudXLS.new_request
      hash_req.config = config_hash
      json_req.config = JSON.generate(config_hash)
      expect(hash_req.config).to eq(json_req.config)
    end
  end

  describe "#stream" do
    it "streams sheet data" do
      req = CloudXLS.new_request
      req.stream do |stream|
        stream.add "name", "data"
      end
    end
  end

  describe "#response_body" do
    it "blocks for response" do
      req = CloudXLS.new_request
      req.stream do |stream|
        stream.add "name1", "data"
        stream.add "name2", "data"
      end
      expect(req.response_body).to eq("datadata")
    end
  end
end
