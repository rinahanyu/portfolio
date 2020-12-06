class Users::MedicalRecordsController < ApplicationController
  before_action :authenticate_hospital!, except: [:index, :show]
  before_action :correct_relationship_id, only: [:index, :show]
  before_action :family_hospital_id, only: [:new, :edit]
  before_action :set_medical_record, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  def new
    @medical_record = MedicalRecord.new
  end

  def create
    @medical_record = MedicalRecord.new(medical_record_params)
    @medical_record.hospital_id = current_hospital.id
    @medical_record.user_id = params[:user_id]
    if @medical_record.save
      NotificationMailer.medical_record_to_user(@user, @medical_record).deliver
      redirect_to user_medical_records_path(@user)
      flash[:notice] = '投稿しました'
    else
      render "new"
    end
  end

  def index
    @medical_records = MedicalRecord.where(user_id: params[:user_id]).order(start_time: :desc)
  end

  def show
  end

  def edit
  end

  def update
    if @medical_record.update(medical_record_params)
      redirect_to user_medical_record_path(@user)
      flash[:notice] = '更新しました'
    else
      render "edit"
    end
  end

  def destroy
    @medical_record.destroy
    redirect_to user_medical_records_path(@user)
    flash[:alert] = '削除しました'
  end

  private
  def set_medical_record
    @medical_record = MedicalRecord.find(params[:id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def medical_record_params
    params.require(:medical_record).permit(:start_time, :doctor, :disease, :treatment)
  end
end
