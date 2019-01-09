class CreateVehicles < ActiveRecord::Migration[5.2]
  def change
    create_table :vehicles do |t|
      t.string :name
      t.string :brand
      t.jsonb :description
      t.jsonb :schema, null: false, default: { "required": ["color"], "attributes": { "color": { "type": "string", "default": "" }, "wheels": { "type": "integer", "default": 2 }, "alarm": { "type": "boolean", "default": false } } }
      t.timestamp
    end

    add_index :vehicles, :description, using: :gin
    add_index :vehicles, :schema, using: :gin
  end
end
