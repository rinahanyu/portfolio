class MedicalRecord < ApplicationRecord
  validates :user_id, :hospital_id, :examined_on, :doctor, :disease, :treatment, presence: true
  belongs_to :user
  belongs_to :hospital
end
