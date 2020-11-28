class MedicalRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :hospital
end
