class Hospitals::HospitalsController < ApplicationController
  before_action :set_hospital, only: [:show, :edit, :update]

  def show
  end

  def edit
  end

  def update
    if @hospital.update(hospital_params)
      redirect_to hospital_path(@hospital)
    else
      render "edit"
    end
  end

  def index
    @hospitals = Hospital.all
  end

  private
  def set_hospital
    @hospital = Hospital.find(params[:id])
  end

  def hospital_params
    params.require(:hospital).permit(:name, :email, :postal_code, :address, :telphone_number)
  end
end
