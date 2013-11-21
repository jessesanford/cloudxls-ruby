require 'spec_helper'

describe "CloudXLS::CSVWriter" do
  before do
    @writer = CloudXLS::CSVWriter
  end

  describe "with array" do
    it "should not titleize" do
      expect( @writer.text([['foo','bar'],[1,2]]) ).to eq("foo,bar\n1,2")
    end

    it "should escape titles" do
      expect( @writer.text([['bar"baz']]) ).to eq("\"bar\"\"baz\"")
    end

    it "should escape rows" do
      expect( @writer.text([['title'],['bar"baz']]) ).to eq("title\n\"bar\"\"baz\"")
    end

    it "should write YYYY-MM-DD for Date" do
      expect( @writer.text([[Date.new(2012,12,24)]]) ).to eq("2012-12-24")
    end

    it "should write xmlschema for DateTime" do
      # TODO: make UTC consistent
      expect( @writer.text([[DateTime.new(2012,12,24,18,30,5,'+0000')]])             ).to eq("2012-12-24T18:30:05.000+0000")
      expect( @writer.text([[DateTime.new(2012,12,24,18,30,5,'+0000').to_time.utc]]) ).to eq("2012-12-24T18:30:05.000+0000")
    end

    it "should write nothing for nil" do
      expect( @writer.text([[nil,nil]]) ).to eq(",")
    end

    it "should write \"\" for empty string" do
      expect( @writer.text([["",""]]) ).to eq('"",""')
    end

    it "should write integers" do
      expect( @writer.text([[-1,0,1,1_000_000]]) ).to eq('-1,0,1,1000000')
    end

    it "should write floats" do
      expect( @writer.text([[-1.0,0.0,1.0,1_000_000.0,1.234567]]) ).to eq('-1.0,0.0,1.0,1000000.0,1.234567')
    end
  end
end