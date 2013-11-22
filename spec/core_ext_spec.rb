require 'spec_helper'

describe "as_csv" do
  it "should handle Hash" do
    expect( {:foo => 1, :bar => Date.new(2013,12,24)}.as_csv ).to eq([1,'2013-12-24'])
  end

  it "should handle Hash with :only" do
    hash =  {:foo => "foo", :bar => "bar"}
    expect( hash.as_csv(:only => :foo) ).to eq(["foo"])
    expect( hash.as_csv(:only => [:foo]) ).to eq(["foo"])
    expect( hash.as_csv(:only => [:bar]) ).to eq(["bar"])
    expect( hash.as_csv(:only => [:foo, :bar]) ).to eq(["foo", "bar"])
    expect( hash.as_csv(:only => [:bar, :foo]) ).to eq(["bar", "foo"])
    #expect( hash.as_csv(:only => [:bar, :baz, :foo]) ).to eq(["foo", nil, "bar"])
  end

  it "should handle Array" do
    expect( [1, Date.new(2013,12,24)].as_csv ).to eq([1,'2013-12-24'])
  end

  it "should handle Symbol" do
    expect( :foo.as_csv ).to eq('foo')
  end

  it "should handle Symbol" do
    expect( :foo.as_csv ).to eq('foo')
  end

  it "should handle nil" do
    expect( nil.as_csv ).to eq(nil)
  end

  it "should handle boolean" do
    expect( false.as_csv ).to eq(false)
    expect( true.as_csv  ).to eq(true)
  end

  it "should handle float" do
    expect( (1.123).as_csv  ).to eq(1.123)
    expect( (1.0/0.0).as_csv  ).to eq("#DIV/0!")
    expect( (-1.0/0.0).as_csv ).to eq("#DIV/0!")
    expect( (0.0/0.0).as_csv  ).to eq("#DIV/0!")
  end

  it "should handle Time"  do
    expect( Time.new(2012,12,24,18,30,5,'+00:00').as_csv ).to eq("2012-12-24T18:30:05.000+0000")
  end

  it "should handle DateTime"  do
    expect( DateTime.new(2012,12,24,18,30,5,'+00:00').as_csv ).to eq("2012-12-24T18:30:05.000+0000")
    expect( DateTime.new(2012,12,24).as_csv ).to eq("2012-12-24T00:00:00.000+0000")
  end

  it "should handle DateTime"  do
    expect( Date.new(2012,12,24).as_csv ).to eq("2012-12-24")
  end
end
