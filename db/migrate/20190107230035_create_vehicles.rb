class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.json :description
      t.json :description_schema
      t.timestamp
    end
  end
end
