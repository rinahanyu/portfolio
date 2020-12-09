class Hospitals::HospitalsController < ApplicationController
  before_action :authenticate_hospital!, except: [:show, :index]
  before_action :all_signed_in, only: [:show, :index]
  before_action :correct_hospital, only: [:edit]
  before_action :set_hospital, only: [:show, :edit, :update]

  def show
    # 個人利用者がアクセスしている場合
    if current_user.present?
      @room1 = Room.where(user_id: current_user.id)
      @room1.each do |r|
        @hospital.rooms.each do |hr|
          if r.id == hr.id
            @isRoom = true
            @roomId = r.id
          end
        end
      end
      unless @isRoom
        @room = Room.new
      end
    end
  end

  def edit
  end

  def update
    if @hospital.update(hospital_params)
      redirect_to hospital_path(@hospital)
      flash[:notice] = '更新しました'
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
