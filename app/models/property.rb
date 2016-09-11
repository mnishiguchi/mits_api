=begin
The Property class represents a piece of data about a property in
our schema. It takes a parsed feed of Hash-type, formats each
field through PropertyField objects and persist each field into
our database. This class itself focuses on persisting data to our database,
while PropertyField objects take care of sanitizing values for each field.
=end

class Property < ApplicationRecord

  validates :uid, presence: :true

  def self.find_or_create_from_feed_hash(hash)
    Property.new do |prop|
      prop.set_formatted_params(hash)
      prop.save!
    end
  end

  def set_formatted_params(hash)
    self.amenities    = PropertyField::Amenities.new(hash).value
    self.address      = PropertyField::Address.new(hash).value
    self.community    = PropertyField::Community.new(hash).value
    self.description  = PropertyField::Description.new(hash).value
    self.emails       = PropertyField::Emails.new(hash).value
    self.floorplans   = PropertyField::Floorplans.new(hash).value
    self.latitude     = PropertyField::Latitude.new(hash).value
    self.longitude    = PropertyField::Longitude.new(hash).value
    self.parking      = PropertyField::Parking.new(hash).value
    self.pet_policy   = PropertyField::PetPolicy.new(hash).value
    self.phones       = PropertyField::Phones.new(hash).value
    self.photos       = PropertyField::Photos.new(hash).value
    self.primary_name = PropertyField::PrimaryName.new(hash).value
    self.uid          = PropertyField::Uid.new(hash).value
    self.urls         = PropertyField::Urls.new(hash).value
    self.utility      = PropertyField::Utility.new(hash).value
    self
  end
end
