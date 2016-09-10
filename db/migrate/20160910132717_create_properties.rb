class CreateProperties < ActiveRecord::Migration[5.0]
  def change
    create_table :properties do |t|
      t.string :name
      t.string :description
      t.json :source
      t.json :community
      t.json :floorplans
      t.json :address
      t.json :utility
      t.timestamps
    end
  end
end
