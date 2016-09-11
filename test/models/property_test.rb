require "test_helper"

def valid_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue Exception => e
    return false
  end
end

describe Property do

  let(:property) do
    # Read a sample json data from a file.
    properties = File.read("db/feeds/parsed_feed_example.json")
    assert valid_json?(properties)
    property_hash = JSON.parse(properties).first
    property = Property.find_or_create_from_feed_hash(property_hash)
    property.reload
  end

  it "#valid?" do
    ap property.errors.messages if property.errors.messages

    assert property.is_a? Property
    assert property.valid?
  end

  it "responds to correct attributes" do
    Property.column_names.each do |attr|
      assert property.send(:respond_to?, attr)
    end
  end

  it "primary_name" do
    assert_equal "Westside Creek", property.primary_name
  end

  it "emails" do
    assert property.emails.is_a? Array
    assert property.emails.include?("WestsideCreek.MAAC@lead2lease.com")
  end

  it "longitude and latitude" do
    assert_equal "-92.42", property.longitude
    assert_equal "34.80", property.latitude
  end

  it "uid" do
    assert_equal "011086", property.uid
  end
end
