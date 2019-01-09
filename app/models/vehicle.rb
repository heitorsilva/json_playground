class Vehicle < ApplicationRecord
  # ----- deal with the serialization
  serialize :description, Description

  validate :validate_description

  def validate_description
    description.validate
    errors.add(:description, "must be valid") if description.errors.any?
  end
end
