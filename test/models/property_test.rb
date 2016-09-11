require "test_helper"

require 'open-uri'
require 'json'

include PropertyField

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

  let(:property) do
     Property.create_or_update_from_hash(@property_hash)
  end

  it "#valid?" do
    assert property.is_a? Property
    assert property.valid?
  end

  it "has correct read-only attributes" do
    attrs = [
      :address,
      :amenities,
      :community,
      :description,
      :floorplans,
      :emails,
      :latitude,
      :longitude,
      :parking,
      :pet_policy,
      :phones,
      :photos,
      :primary_name,
      :uid,
      :urls,
      :utility
    ].each do |attr|
      assert {property.send(:respond_to?, attr)}
    end
  end

  # it "primaty_name" do
  #   assert_equal "Westside Creek", property.primary_name
  # end
  #
  # it "emails" do
  #   assert {property.emails.include?("WestsideCreek.MAAC@lead2lease.com")}
  # end
  #
  # it "longitude and latitude" do
  #   assert_equal "-92.42", property.longitude
  #   assert_equal "34.80", property.latitude
  # end
  #
  # it "uid" do
  #   assert_equal "011086", property.uid
  # end
end
