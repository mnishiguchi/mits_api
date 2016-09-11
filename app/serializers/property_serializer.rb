class PropertySerializer < ActiveModel::Serializer
  attributes *Property.column_names

  # attributes :id,
  #   :created_at,
  #   :updated_at,
  #   :address,
  #   :amenities,
  #   :community,
  #   :description,
  #   :floorplans,
  #   :emails,
  #   :latitude,
  #   :longitude,
  #   :parking,
  #   :pet_policy,
  #   :phones,
  #   :photos,
  #   :primary_name,
  #   :uid,
  #   :urls,
  #   :utility
end
