class Hospitals::MedicalRelationshipsController < ApplicationController
  def create
    family = current_user.medical_relationships.build(hospital_id: params[:hospital_id])
    family.save
    redirect_to hospital_path(params[:hospital_id])
  end

  def destroy
    family = current_user.medical_relationships.find_by(hospital_id: params[:hospital_id])
    family.destroy
    redirect_to hospital_path(params[:hospital_id])
  end
end
