class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :brand
      t.jsonb :description
      t.timestamp
    end

    add_index :vehicles, :description, using: :gin
  end
end
