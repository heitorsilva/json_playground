class Description
  SCHEMA = '{ "required": ["name", "brand"], "attributes": { "name": { "type": "string", "default": "", "value": "" }, "brand": { "type": "string", "default": "", "value": "" }, "wheels": { "type": "integer", "default": 2, "value": 2 } } }'

  def initialize(data)
    @attributes = {}

    load_schema data
    set_values data
  end

  def attributes
    @attributes
  end

  def attribute_names
    @attributes.keys
  end

  def self.dump(description)
    if description.is_a?(self)
      description.attributes
    else
      description[:attributes]
    end.to_json
  end

  def self.load(values)
    data = values || SCHEMA
    new( (JSON.parse(data)).with_indifferent_access )
  end

  private

  def load_schema(data)
    field_names = has_schema?(data) ? fields_from_schema(data) : data.keys

    field_names.each do |field_name|
      define_singleton_method field_name do
        @attributes[field_name]
      end

      define_singleton_method field_name.to_s + "=" do |val|
        @attributes[field_name] = val
      end
    end
  end

  def has_schema?(data)
    data[:attributes].present?
  end

  def fields_from_schema(schema)
    schema[:attributes].keys
  end

  def set_values(data)
    data_hash = has_schema?(data) ? values_from_schema(data) : data
    data_hash.each do |k, v|
      self.send k.to_s + "=", v
    end
  end

  def values_from_schema(schema)
    schema[:attributes].map do |field_name, field_data|
      [field_name, field_data[:default]]
    end.to_h.with_indifferent_access
  end

end
