# Represents any kind of vehicles
class Vehicle < ApplicationRecord
  serialize :description, Description

  validates :name, :brand, presence: true
  validate :validate_description

  after_initialize :delegate_description_fields

  private

  def delegate_description_fields
    description._schema.with_indifferent_access["attributes"].keys.each do |attr_name|
      singleton_class.delegate attr_name, to: :description
      singleton_class.delegate attr_name + '=', to: :description
    end
  end

  def validate_description
    description.validate
    errors.add(:description, "must be valid") if description.errors.any?
  end
end
