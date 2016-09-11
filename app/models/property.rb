require 'json'

=begin
The Property class represents a piece of data about a property in
our schema. It takes a parsed feed in JSON or Hash, format each
field through PropertyField objects and persist each field into
our database
=end

class Property < ApplicationRecord
  attr_reader :source,  # The source hash
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

  def self.create_or_update_from_hash(hash)

    # binding.pry

    property = Property.find_or_create_by(uid: hash["uid"])
    property.update_attributes(Property.property_params(hash))
    property
  end

  def self.property_params(hash)
    {
      amenities: PropertyField::Amenities.new(hash).value,
      address: PropertyField::Address.new(hash).value,
      community: PropertyField::Community.new(hash).value,
      description: PropertyField::Description.new(hash).value,
      emails: PropertyField::Email.new(hash).value,
      floorplans: PropertyField::Floorplans.new(hash).value,
      latitude: PropertyField::Latitude.new(hash).value,
      longitude: PropertyField::Longitude.new(hash).value,
      parking: PropertyField::Parking.new(hash).value,
      pet_policy: PropertyField::PetPolicy.new(hash).value,
      phones: PropertyField::Phones.new(hash).value,
      primary_name: PropertyField::PrimaryName.new(hash).value,
      photos: PropertyField::Photos.new(hash).value,
      uid: PropertyField::Uid.new(hash).value,
      urls: PropertyField::Urls.new(hash).value,
      utility: PropertyField::Utility.new(hash).value
    }
  end
end
