require 'spec_helper'

describe "CloudXLSRequest" do
  describe "#config" do
    let(:req) { CloudXLS.start }
    let(:hsh) { {k1: "v", k2: "v"} }
    let(:jsn) { JSON.generate(hsh) }
    it "can be provided as json" do
      req.config = jsn
      expect(req.config).to eq(jsn)
    end

    it "or it is converted to json" do
      req.config = hsh
      expect(req.config).to eq(jsn)
    end

    it "can't be set twice" do
      req.config = hsh
      expect{req.config = jsn}.to raise_error(StandardError)
    end
  end

  describe "#add" do
    let(:data) { {n1: "csv,data", n2: "data,csv"} }
    it "streams sheet data by sheet name" do
      req = CloudXLS.start do |r|
        data.each do |n,d|
          r.add(n) do |s|
            s << d
          end
        end
      end
      data.each do |n,d|
        expect(req.data[n]).to eq(d)
      end
    end

    it "raises error if data added twice" do
      expect {
        CloudXLS.start do |r|
          2.times do
            r.add("n1") do |s|
              s << "csv,data"
            end
          end
        end
      }.to raise_error(StandardError)
    end
  end

  describe "#response_body" do
    it "" do
    end
  end
end
