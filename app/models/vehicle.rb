# Represents any kind of vehicles
class Vehicle < ApplicationRecord
  serialize :description, Description

  after_initialize :delegate_description_fields

  def delegate_description_fields
    description.attribute_names.each do |attr_name|
      singleton_class.delegate attr_name, to: :description
      singleton_class.delegate attr_name + '=', to: :description
    end
  end
end
