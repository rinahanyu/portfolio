class MedicalHistory < ApplicationRecord
  belongs_to :user

  validates :disease, :started_on, :treatment, :hospital , presence: true
end
