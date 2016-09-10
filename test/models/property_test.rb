require "test_helper"

require 'open-uri'
require 'json'

def valid_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue Exception => e
    return false
  end
end

describe Property do

  before do
    # Read a sample json data from a file.
    properties = open("db/feeds/parsed_feed_example.json") { |io| io.read }
    assert valid_json?(properties)
    @property_hash = JSON.parse(properties).first
  end

  it ".new.from_hash" do
    property = Property.new
    property.from_hash(@property_hash)
    assert property.is_a? Property
  end

  it ".new.from_json(json)" do
    property = Property.new
    property.from_hash(@property_hash)
    assert property.is_a? Property
  end

  it "has correct read-only attributes" do
    property = Property.new
    property.from_hash(@property_hash)

    %w(source community floorplans address utility).each do |attr|
      assert property.send(:respond_to?, attr.to_sym)
      refute property.send(:respond_to?, "#{attr}=".to_sym)
    end
  end
end
