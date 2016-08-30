require "nori"
require "awesome_print"
require "pry"

#
# The Nori gem converts an XML file into a Ruby hash.
#

# Check current working directory.
puts Dir.pwd

# absolute path to the source XML file.
filename = "/Users/mnishiguchi/projects/sample_mits/db/feeds/aimco.xml"
# filename = "/Users/masa/projects/ruby/parse_xml/db/feeds/ash_a.xml"
p filename

# Read that file.
xml = File.read(filename)

# Parse xml using Nori.
parser = Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
doc = parser.parse(xml)

binding.pry

# Pretty-print the hash that is parsed from XML.
ap doc

=begin
hash.keys
=> ["PhysicalProperty"]

hash["PhysicalProperty"].keys
=> ["Management",
 "Property",
 "@xmlns:xsi",
 "@xmlns:xsd",
 "@xmlns:MITS"]

hash["PhysicalProperty"]["Management"].keys
=> ["Name", "WebSite", "@id"]

hash["PhysicalProperty"]["Property"].keys
=> ["Identification",
"Information",
"Policy",
"Floorplan",
"Amenities",
"File",
"@managementID"]

hash["PhysicalProperty"]["Property"]["Identification
"].keys
=> ["PrimaryID",
 "MarketingName",
 "OwnerLegalName",
 "Address",
 "Latitude",
 "Longitude",
 "Phone",
 "Fax",
 "Email",
 "@Type",
 "@RentalType"]

hash["PhysicalProperty"]["Property"]["Information"].
keys
=> ["UnitCount",
 "YearBuilt",
 "LeaseLength",
 "OfficeHour",
 "LongDescription",
 "DrivingDirections"]

hash["PhysicalProperty"]["Property"]["Policy"].keys
=> ["Pet", "General"]

hash["PhysicalProperty"]["Property"]["Floorplan"]
=> Array

hash["PhysicalProperty"]["Property"]["Amenities"].ke
ys
=> ["Community", "Floorplan", "General"]

=end
