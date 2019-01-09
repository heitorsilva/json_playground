# unfortunately, we do not have access to the parent model in this coder.
# so we must include the schema here.
#
#
# Test code (also see in test folder):
#   # invalid creation
#   reload!; Vehicle.delete_all; v=Vehicle.new; v.description.name = "abc"; v.save
#   # creation
#   reload!; Vehicle.delete_all; v=Vehicle.new; v.description.name = "abc"; v.description.brand = "fish"; v.save
#   # accessing the save thing
#   reload!; v = Vehicle.first; v.description.name
#   # change the schema
#   Vehicle.delete_all
#   v = Vehicle.new; v.description.name = "some name"; v.description.brand = "some brand"; v.save
#   schema = { "required" => ["fish"], "attributes" => { "name": { "type": "string", "default": "", "value": ""} , "fish": { "type": "string", "default": "", "value": "" } } }
#   raw_description = { "_schema" => schema, "name" => "yummi", "fish" => "yummi" }
#   v.update_columns(description: raw_description)
#   v = Vehicle.first

class Description
  class << self
    def load(db_contents)
      return Description.new if db_contents.nil? # copy comment from the other version
      return Description.new(JSON.parse(db_contents))
    end

    # Problem:
    # When updating the record from a param, Rails does not pass in the prior value of the description attribute to the dump method.
    # Yet, we need it for the schema. Hence, we need to do a little controller magic (see there).
    def dump(description_or_param)
      description = description_or_param.is_a?(Hash) ? Description.new(description_or_param) : description_or_param
      return JSON.dump(description.hash_for_serialization)
    end

    # Please see above for the problem rationale and why this is needed.
    # Use this in the controller's update action:
    #   params = vehicle_params
    #   Description.enrich_params!(params, @vehicle)
    #   if @vehicle.update(params)
    #     # ...
    def enrich_params!(params, parent_model, field_name=:description)
      params[field_name.to_s]["_schema"] = parent_model.send(field_name.to_sym)._schema
    end
  end

  include ActiveModel::Model

  # ----- logic to pre-set the schema
  DEFAULT_SCHEMA = {
    "required" => ["name", "brand"],
    "attributes" => { "name": { "type": "string", "default": "", "value": "" },
      "brand": { "type": "string", "default": "", "value": "" },
      "wheels": { "type": "integer", "default": 2, "value": 2 } } }

  attr_accessor :_schema

  def initialize(attributes={})
    @_schema = attributes["_schema"] || DEFAULT_SCHEMA # we need to load the schema before the mass assignment in super
    @values = {}
    define_attribute_methods
    super
  end

  # ----- getter for serialization
  def hash_for_serialization
    return @values.merge({ _schema: self._schema })
  end

  # ----- logic to provide custom attributes
  def define_attribute_methods
    fields_in_schema.each do |field_name|
      define_singleton_method field_name.to_sym do
        @values[field_name]
      end

      define_singleton_method "#{field_name}=".to_sym do |val|
        @values[field_name] = val
      end
    end
  end

  # somehow the validations are not called in this object, so we need to tigger this from the outside
  def validate
    # I am now testing only presence...
    @_schema["required"].each do |field|
      errors.add(field, "is required") if @values[field].blank?
    end
  end

  # in this method we return with the details of the fields (we just pass the schema's attributes through).
  # this is used to render the fields in the form view
  def field_info
    return @_schema["attributes"]
  end

  protected

  # ----- logic for validations
  def fields_in_schema
    return @_schema["attributes"].keys.collect(&:to_s)
  end
end
