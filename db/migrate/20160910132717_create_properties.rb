class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.json :address
      t.json :amenities
      t.json :community
      t.text   :description
      t.json :floorplans
      t.string :emails, array: true, default: []
      t.string :latitude
      t.string :longitude
      t.string :parking, array: true, default: []
      t.json :pet_policy
      t.json :phones
      t.json :photos
      t.string :primary_name
      t.string :uid
      t.json :urls
      t.json :utility

      t.timestamps
    end
  end
end
