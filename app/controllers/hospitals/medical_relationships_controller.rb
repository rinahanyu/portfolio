class Hospitals::MedicalRelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    family = current_user.medical_relationships.build(
      hospital_id: params[:hospital][:hospital_id])
    family.save
    redirect_to hospital_path(params[:hospital][:hospital_id])
    flash[:notice] = 'かかりつけ医登録しました'
  end

  def destroy
    family = current_user.medical_relationships.find_by(
      hospital_id: params[:hospital][:hospital_id])
    family.destroy
    redirect_to hospital_path(params[:hospital][:hospital_id])
    flash[:alert] = 'かかりつけ医登録を解除しました'
  end
end
