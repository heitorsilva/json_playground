class Description
  class << self
    def load(db_contents)
      return Description.new if db_contents.nil?
      db_contents = JSON.parse(db_contents) if db_contents.is_a? String
      Description.new(db_contents)
    end

    def dump(description_or_param)
      description = description_or_param.is_a?(Hash) ? Description.new(description_or_param) : description_or_param
      JSON.dump(description.hash_for_serialization)
    end

    def enrich_params!(params, parent_model, field_name=:description)
      params[field_name.to_s]["_schema"] = parent_model.send(field_name.to_sym)._schema
      params
    end
  end

  include ActiveModel::Model

  DEFAULT_SCHEMA = { "required": ["color"], "attributes": { "color": { "type": "string", "default": "" }, "wheels": { "type": "integer", "default": 2 }, "alarm": { "type": "boolean", "default": false } } }

  attr_accessor :_schema

  def initialize(attributes={})
    @values = {}
    @_schema = attributes["_schema"] || DEFAULT_SCHEMA

    define_methods(@_schema.with_indifferent_access["attributes"])

    super
  end

  def hash_for_serialization
    define_default_values
    define_missing_values

    return @values.merge({ _schema: self._schema })
  end

  def validate
    @_schema.with_indifferent_access["required"].each do |field|
      errors.add(field, "is required") if @values[field].blank?
    end
  end

  def field_info
    @_schema.with_indifferent_access["attributes"]
  end

  private

  def define_default_values
    @values.each do |field, value|
      @values[field] = self._schema.with_indifferent_access["attributes"][field]["default"] if value.blank?
    end
  end

  def define_methods(data)
    data.keys.each do |field|
      define_singleton_method field do
        @values[field]
      end

      define_singleton_method "#{field}=" do |val|
        @values[field] = val
      end
    end
  end

  def define_missing_values
    schema_attributes = self._schema.with_indifferent_access["attributes"].keys

    difference = schema_attributes - @values.keys
    difference.each do |field|
      @values[field] = self._schema.with_indifferent_access["attributes"][field]["default"]
    end
  end
end
