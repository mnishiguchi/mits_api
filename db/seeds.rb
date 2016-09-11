Property.delete_all

json = File.read("db/feeds/parsed_feed_example.json")
properties = JSON.parse(json)

properties.each do |hash|
  ap Property.find_or_create_from_feed_hash(hash)
end

puts "-" * 50
puts "count        => #{Property.count}"
puts "uid          => #{Property.pluck :uid}"
puts "primary_name => #{Property.pluck :primary_name}"
puts "-" * 50
