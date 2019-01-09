# Represents any kind of vehicles
class Vehicle < ApplicationRecord
  validates :name, :brand, presence: true

  store_accessor :schema, :required, :attributes
  serialize :description

  after_initialize :define_default_values
  before_save :define_missing_values

  before_validation :validate_from_schema

  private

  def define_default_values
    return unless self.description.blank?
    self.description = {}
    self.schema['attributes'].keys.each do |field|
      self.description[field] = self.schema['attributes'][field]['default']
    end
  end

  def define_missing_values
    difference = self.schema['attributes'].keys - self.description.keys
    difference.each do |field|
      self.description[field] = self.schema['attributes'][field]['default']
    end
  end

  def validate_from_schema
    self.schema['required'].each do |field|
      errors.add(field, 'is required') if self.description[field].blank?
    end
  end
end
