=begin
The PropertyField class provides us with a single location to
configure each fields of the Properties table. Its initializer
takes a feed hash. We create subclasses of the Base class that
correspond to the Property model's column names and specify how
to determine the value for each field.

Usage:
  address = PropertyField::Address.new(hash).value
=end

module PropertyField

  class Base
    attr_reader :value

    def initialize(hash)
      raise "Must be a hash" unless hash.is_a? Hash
      # hash.symbolize_keys!
    end
  end


  # ===
  # Subclasses that correspond to the Properties table's column names.
  # ===


  class Address < PropertyField::Base
    def initialize(hash)
      super
      @address = hash["address"]
      format_empty_values!
      @value = @address.to_json
    end

    def format_empty_values!
      @address = @address.map { |k, v| (/n\/a/i =~ v) ? [k, ""] : [k, v] }.to_h
    end
  end

  class Amenities < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["menities"].to_json
    end
  end

  class Community < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["amenities"]["community"]
    end
  end

  class Emails < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["emails"].values
    end
  end

  class Description < PropertyField::Base
    def initialize(hash)
      super
      @value = "Lorem"
    end
  end

  class Floorplans < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["floorplans"].to_json
    end
  end

  class Latitude < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["latitude"]
    end
  end

  class Longitude < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["longitude"]
    end
  end

  class Parking < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["parking"]
    end
  end

  class PetPolicy < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["pet_policy"].to_json
    end
  end

  class Phones < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["phones"].to_json
    end
  end

  class PrimaryName < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["primary_name"]
    end
  end

  class Photos < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["photos"].to_json
    end
  end

  class Uid < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["uniq_id"]
    end
  end

  class Urls < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["urls"].to_json
    end
  end

  class Utility < PropertyField::Base
    def initialize(hash)
      super
      @value = hash["utility"].to_json
    end
  end
end
