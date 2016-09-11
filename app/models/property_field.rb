=begin
The PropertyField class provides us with a single location to
configure each fields of the Properties table. Its initializer
takes a feed hash and we specify how to determine the value for
a given field.

Usage:
  address = PropertyField::Address.new(hash).value
=end

module PropertyField

  class Base
    attr_reader :value

    def initialize(hash)
      raise "Must be a hash" unless hash.is_a? Hash
      hash.symbolize_keys!
    end
  end

  class Address < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:address].to_s
    end
  end

  class Amenities < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:menities].to_s
    end
  end

  class Community < PropertyField::Base
    def initialize(hash)
      super
      @value = ""
    end
  end

  class Email < PropertyField::Base
    def initialize(hash)
      super
      @value = ["some@email.com"]
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
      @value = hash[:floorplans].to_s
    end
  end

  class Latitude < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:latitude]
    end
  end

  class Longitude < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:longitude]
    end
  end

  class Parking < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:parking].to_s
    end
  end

  class PetPolicy < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:pet_policy].to_s
    end
  end

  class Phones < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:phones]
    end
  end

  class PrimaryName < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:primary_name]
    end
  end

  class Photos < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:photos].to_s
    end
  end

  class Uid < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:uniq_id]
    end
  end

  class Urls < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:urls].to_s
    end
  end

  class Utility < PropertyField::Base
    def initialize(hash)
      super
      @value = hash[:utility].to_s
    end
  end
end
