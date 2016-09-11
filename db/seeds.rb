# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Property.destroy_all

json = File.read("db/feeds/parsed_feed_example.json")
properties = JSON.parse(json)

properties.each do |hash|
  Property.create_or_update_from_hash(hash)
end
