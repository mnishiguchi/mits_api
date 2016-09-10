class MitsParser
  def self.dig_any(hash, default_value, *set_of_paths)
    set_of_paths.each do |paths|
      result = MitsParser.dig(hash, paths)
      result = result.compact.flatten if result.is_a?(Array)
      next if result.blank?
      return result
    end
    default_value
  end

  def self.dig_all(hash, *set_of_paths)
    {}.tap do |results|
      set_of_paths.each do |paths|
        result = MitsParser.dig(hash, paths)
        result = result.compact.flatten if result.is_a?(Array)
        next if result.blank?
        results[paths.join.underscore.to_sym] = result
      end
    end
  end

  def self.dig(hash, paths)
    return hash if paths.empty?
    return {} unless hash

    path            = paths.first
    remaining_paths = paths[1...paths.size]

    if path == "Array"
      # Coercion or, simplify it from above
      hash.map do |h|
        MitsParser.dig(h, remaining_paths)
      end
    elsif hash.is_a?(Hash) && (new_hash = hash[path])
      MitsParser.dig(new_hash, remaining_paths)
    else
      []
    end
  end

  class Amenities
    TRANSFORM_KEYS = {
      "Availability24Hours" => "AlwaysAvailable",
      "Available24Hours"    => "AlwaysAvailable",
      "WD_Hookup"           => "WasherDryerHookup"
    }

    TRANSFORM_VALUES = {
      ""      => nil,
      "f"     => false,
      "F"     => false,
      "false" => false,
      "False" => false,
      "0"     => false,
      "t"     => true,
      "T"     => true,
      "true"  => true,
      "True"  => true,
      "1"     => true,
    }

    def self.community(hash)
      fix(MitsParser.dig(hash, %w(Amenities Community)))
    end

    def self.floorplans(hash)
      fix(MitsParser.dig(hash, %w(Amenities Floorplan)))
    end

    def self.fix(hash)
      {}.tap do |new_hash|
        hash.each do |key, value|
          transformed_key   = TRANSFORM_KEYS.key?(key) ? TRANSFORM_KEYS[key] : key
          transformed_key   = transformed_key.underscore.to_sym if transformed_key

          transformed_value =  TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [transformed_key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.blank?
          next if transformed_value.is_a?(Array) && transformed_value.blank?

          new_hash[transformed_key] = transformed_value
        end
      end
    end
  end

  class Utility
    TRANSFORM_KEYS = {
      "AirCon" => "AirConditioning"
    }

    TRANSFORM_VALUES = {
      ""      => nil,
      "f"     => false,
      "F"     => false,
      "false" => false,
      "False" => false,
      "0"     => false,
      "t"     => true,
      "T"     => true,
      "true"  => true,
      "True"  => true,
      "1"     => true,
    }

    def self.parse(hash)
      fix(MitsParser.dig(hash, %w(Utility)))
    end

    def self.fix(hash)
      {}.tap do |new_hash|
        hash.each do |key, value|
          transformed_key   = TRANSFORM_KEYS.key?(key) ? TRANSFORM_KEYS[key] : key
          transformed_key   = transformed_key.underscore.to_sym if transformed_key

          transformed_value =  TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [transformed_key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.blank?
          next if transformed_value.is_a?(Array) && transformed_value.blank?

          new_hash[transformed_key] = transformed_value
        end
      end
    end
  end

  class Address
    def self.parse(hash)
      fix({
            address: MitsParser.dig_any(hash, "", %w(Identification Address Address1), %w(Identification Address ShippingAddress), %w(Identification Address MailingAddress), %w(PropertyID Address Address), %w(PropertyID Address Address1)),
            city:    MitsParser.dig_any(hash, "", %w(Identification Address City), %w(PropertyID Address City)),
            county:  MitsParser.dig_any(hash, "", %w(PropertyID Address CountyName)),
            zip:     MitsParser.dig_any(hash, "", %w(Identification Address Zip), %w(PropertyID Address Zip)),
            po_box:  MitsParser.dig_any(hash, "", %w(Identification Address PO_Box)),
            country: MitsParser.dig_any(hash, "USA", %w(Identification Address Country)),
            state:   MitsParser.dig_any(hash, "", %w(Identification Address State)),
          })
    end

    TRANSFORM_VALUES = {
      "N/A" => ""
    }

    def self.fix(hash)
      {}.tap do |new_hash|
        hash.each do |key, value|

          transformed_value = TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.blank?
          next if transformed_value.is_a?(Array) && transformed_value.blank?

          new_hash[key] = transformed_value
        end
      end
    end
  end

  class Photo
    def self.parse(hash)
      photo_hashes = MitsParser.dig(hash, %w(File Array)).compact.select { |file| file.is_a?(Hash) && (file.key?("FileType") || file.key?("Format")) }
      photo_hashes = photo_hashes.map do |photo_hash|
        fix(photo_hash)
      end
      floorplan_photos, photo_hashes = photo_hashes.partition { |file| file[:type] == "floorplan" }

      # Index them because that makes life easier
      floorplan_photo_hashes = {}
      floorplan_photos.each do |floorplan_photo|
        floorplan_photo_hashes[floorplan_photo[:name]] = floorplan_photo if floorplan_photo[:name]
        floorplan_photo_hashes[floorplan_photo[:id]] = floorplan_photo   if floorplan_photo[:id]
      end

      {
        floorplan_photos: floorplan_photo_hashes,
        community_photos: photo_hashes
      }
    end

    def self.floorplan_photos(hash)
      Photo.parse(hash)[:floorplan_photos]
    end

    def self.community_photos(hash)
      Photo.parse(hash)[:community_photos]
    end

    TRANSFORM_KEYS = {
      "Rank"        => nil,         # Drop Rank
      "Caption"     => nil,         # Drop Caption
      "AffiliateId" => "Id",        # Convert to standardized Id
      "Src"         => "SourceUrl"
    }
    TRANSFORM_VALUES = {
      "image/jpeg" => "jpg",
      "JPG"        => "jpg",
      "jpg"        => "jpg",
      "png"        => "png",
      "gif"        => "gif",
      "PNG"        => "png"
    }

    def self.fix(hash)
      {}.tap do |new_hash|
        hash.each do |key, value|
          transformed_key   = TRANSFORM_KEYS.key?(key) ? TRANSFORM_KEYS[key] : key
          transformed_key   = transformed_key.underscore.to_sym if transformed_key

          transformed_value =  TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [transformed_key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.blank?
          next if transformed_value.is_a?(Array) && transformed_value.blank?

          new_hash[transformed_key] = transformed_value
        end
      end
    end
  end

  class Parking
    def self.parse(hash)
      parking_hash = MitsParser.dig(hash, %w(Information Parking))
      return {} unless parking_hash

      # We have some of the keys nested in an array - but the rest are not - Might want to make a method out of this if it becomes an issue
      parking_array = MitsParser.dig(parking_hash, %w(Array)).map { |parking_array_hash| Parking.fix(parking_array_hash) }.compact
      parking_array.tap do |parking_arrays|
        other_parking_array_hashes = MitsParser.dig_all(parking_hash, * %w(Assigned AssignedFee Comment SpaceFee Spaces).map { |a| Array(a) })
        parking_arrays << Parking.fix(other_parking_array_hashes) if other_parking_array_hashes && other_parking_array_hashes != {}
      end
    end

    TRANSFORM_VALUES = {
      "free" => 0,
      "true" => true,
      "false" => false
    }

    def self.fix(hash)
      {}.tap do |new_hash|
        hash.each do |key, value|
          key = key.underscore.to_sym if key.is_a?(String)

          transformed_value =  TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.empty?

          new_hash[key] = transformed_value
        end
      end
    end
  end

  class OfficeHours

    def self.parse_date(string_time)
      return string_time if ["Closed", "By Appointment Only"].include?(string_time)
      Time.parse(string_time).strftime("%R %p")
    end

    TRANSFORM_DAYS = {
      "su" => :sunday,
      "m"  => :monday,
      "t"  => :tuesday,
      "w"  => :wednesday,
      "th" => :thursday,
      "f"  => :friday,
      "sa" => :saturday,

      "sunday"    => :sunday,
      "monday"    => :monday,
      "tuesday"   => :tuesday,
      "wednesday" => :wednesday,
      "thursday"  => :thursday,
      "friday"    => :friday,
      "saturday"  => :saturday
    }

    def self.parse(hash)
      office_hours_by_day = MitsParser.dig(hash, %w(Information OfficeHour))
      {}.tap do |office_hour_hash|
        office_hours_by_day.each do |office_hour_day|
          day = office_hour_day["Day"].downcase
          day = TRANSFORM_DAYS[day] if TRANSFORM_DAYS.key?(day)
          office_hour_hash[day] = {
            open:  OfficeHours.parse_date(office_hour_day["OpenTime"]),
            close: OfficeHours.parse_date(office_hour_day["CloseTime"])
          }
        end
      end
    end

  end

  class PetPolicy
    TRANSFORM_KEYS = {
      "Availability24Hours" => "AlwaysAvailable",
      "Available24Hours"    => "AlwaysAvailable",
      "WD_Hookup"           => "WasherDryerHookup"
    }

    TRANSFORM_VALUES = {
      ""      => nil,
      "false" => false,
      "False" => false,
      "true"  => true,
      "True"  => true,
    }

    def self.parse(hash)
      # fix(MitsParser.dig(hash, %w(Policy Pet)))
      policy_pet_hash = MitsParser.dig(hash, %w(Policy Pet))

      # We have some of the keys nested in an array - but the rest are not - Might want to make a method out of this if it becomes an issue
      policy_pet_array = MitsParser.dig(policy_pet_hash, %w(Array)).map { |policy_pet_array_hash| PetPolicy.fix(policy_pet_array_hash) }.compact
      policy_pet_array.tap do |policy_pet_arrays|
        other_policy_pet_array_hashes = MitsParser.dig_all(policy_pet_hash, * %w(Comment Deposit Fee MaxCount PetCare Rent Restrictions Weight).map { |a| Array(a) })
        policy_pet_arrays << other_policy_pet_array_hashes if other_policy_pet_array_hashes && other_policy_pet_array_hashes != {}
      end

      {
        general:   MitsParser.dig(hash, %w(Policy General)),
        specifics: policy_pet_hash
      }
    end

    def self.fix(hash)
      return if hash.is_a?(Array)
      {}.tap do |new_hash|
        hash.each do |key, value|
          transformed_key   = TRANSFORM_KEYS.key?(key) ? TRANSFORM_KEYS[key] : key
          transformed_key   = transformed_key.underscore.to_sym if transformed_key

          transformed_value =  TRANSFORM_VALUES.key?(value) ? TRANSFORM_VALUES[value] : value

          next if [transformed_key, transformed_value].any?(&:nil?)
          next if transformed_value.is_a?(Hash) && transformed_value.empty?

          new_hash[transformed_key] = transformed_value
        end
      end
    end
  end

  class Floorplan
    # = Photos.floorplan_photos(hash)
    def self.parse(hash, floorplan_photos)
      hashes = MitsParser.dig(hash, %w(Floorplan Array))
      hashes.map do |floorplan_hash|
        case floorplan_hash
        when Hash
          {
            name:       floorplan_hash.fetch("Name", "No Name"),
            unit_count: floorplan_hash.fetch("UnitCount", "0"),
            units_available: {
              today:     floorplan_hash.fetch("UnitsAvailable", 0),
              one_month: floorplan_hash.fetch("UnitsAvailable30Days", 0),
              two_month: floorplan_hash.fetch("UnitsAvailable60Days", 0),
            },
            bathrooms:      floorplan_hash.fetch("Room", []).select { |floorplan_hash| floorplan_hash["Comment"] == "Bathrooms" }.map { |a| a.fetch("Count", 0).to_i + a.fetch("Size", 0).to_i }.sum,
            bedrooms:       floorplan_hash.fetch("Room", []).select { |floorplan_hash| floorplan_hash["Comment"] == "Bedrooms"  }.map { |a| a.fetch("Count", 0).to_i + a.fetch("Size", 0).to_i }.sum,
            photo:          floorplan_photos[floorplan_hash["Name"]],
            unique_feed_id: floorplan_hash["id"]
          }
        when Array
          {}
        end
      end
    end
  end


  class PropertyParser
    def self.parse(hash)
      photos = Photo.parse(hash)
      latitude  = MitsParser.dig_any(hash, "0", %w(Identification Latitude),  %w(ILS_Identification Latitude),  %w(PropertyID Identification Latitude)).to_f
      longitude = MitsParser.dig_any(hash, "0", %w(Identification Longitude),  %w(ILS_Identification Longitude),  %w(PropertyID Identification Longitude)).to_f

      {
        names:             MitsParser.dig_all(hash, %w(Identification MarketingName), %w(PropertyID Identification MarketingName), %w(PropertyID MarketingName), %w(Identification MSA_Name), %w(Identification MSA_Number), %w(Identification OwnerLegalName)),
        emails:            MitsParser.dig_all(hash, %w(PropertyID Address Lead2LeaseEmail),  %w(PropertyID Address Email), %w(Identification Email), %w(OnSiteContact Email)),

        floorplans:        Floorplan.parse(hash, photos[:floorplan_photos]),

        descriptions:      MitsParser.dig_all(hash, %w(Information LongDescription), %w(Information NeighborhoodText), %w(Information OverviewBullet1), %w(Information OverviewBullet2), %w(Information OverviewBullet3), %w(Information OverviewText), %w(Information OverviewTextStripped), %w(Information ShortDescription)),

        office_hours:      OfficeHours.parse(hash),

        longitude:         longitude,
        latitude:          latitude,

        phones:            MitsParser.dig_all(hash, %w(Identification Phone Number), %w(Identification Phone Array), %w(Identification Fax Number), %w(PropertyID Phone PhoneNumber), %w(OnSiteContact Phone Number)),

        urls:              MitsParser.dig_all(hash, %w(Identification Website), %w(Identification WebSite), %w(Identification General_ID ID), %w(Information DirectionsURL), %w(Information FacebookURL), %w(Information ListingImageURL), %w(Information PropertyAvailabilityURL), %w(Information VideoURL), %w(PropertyID Identification BozzutoURL), %w(PropertyID Identification WebSite), %w(PropertyID WebSite), %w(Payment CheckPayable), %w(Floorplan Amenities General)),
        photos:            photos[:community_photos],
        pet_policy:        PetPolicy.parse(hash),

        # Might be able to do searches in here like lease length
        promotional_info:  MitsParser.dig_any(hash, "", %w(Promotional)),
        amenities:         Amenities.community(hash),
        utility:           Utility.parse(hash),
        address:           Address.parse(hash),
        parking:           Parking.parse(hash),
        lease_length:      lease_length(hash),
        unique_feed_id:    MitsParser.dig_all(hash, %w(PropertyID Identification PrimaryID), %w(Identification PrimaryID), %w(Identification SecondaryID), %w(Identification IDValue), %w(Identification General_ID ID)),
        information:       MitsParser.dig_all(hash, %w(Information YearBuilt), %w(Information YearRemodeled), %w(Identification TwitterHandle), %w(Identification IDValue), %w(Information NumberOfAcres), %w(Information LeaseLength), %w(Information BuildingCount), %w(Information UnitCount)),
      }
    end

    def self.lease_length(hash)
      lease_length = MitsParser.dig(hash, %w(Information LeaseLength))
      return { message: "Unknown" } if [nil, [], {}].include?(lease_length)

      lease_lengths = lease_length.scan(/\d+/)
      return { message: lease_length    } if lease_lengths.empty?
      return { min: lease_lengths.first } if lease_lengths.size == 1
      return { min: lease_lengths.min, max: lease_lengths.max }
    end
  end

  def self.parse_properties(properties_json)
    (properties_json["Property"] || []).map do |property|
      PropertyParser.parse(property)
    end
  end
end
