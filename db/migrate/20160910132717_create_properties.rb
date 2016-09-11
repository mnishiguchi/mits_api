class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :address
      t.string :amenities
      t.string :community
      t.text   :description
      t.string :floorplans
      t.string :emails, array: true
      t.string :latitude
      t.string :longitude
      t.string :parking
      t.string :pet_policy
      t.string :phones
      t.string :photos
      t.string :primary_name
      t.string :uid
      t.string :urls
      t.string :utility

      t.timestamps
    end
  end
end
