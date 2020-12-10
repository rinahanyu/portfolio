class Users::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show, :families]
  before_action :correct_relationship, only: [:families]
  before_action :correct_user, only: [:edit]
  before_action :set_user

  def show
    @daily_records = @user.daily_records.order(created_at: :desc).page(params[:page]).per(5)
    # 医療機関関係者がアクセスしている場合
    if current_hospital.present?
      @room1 = Room.where(hospital_id: current_hospital.id)
      @room1.each do |r|
        @user.rooms.each do |ur|
          if r.id == ur.id
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
    if @user.update(user_params)
      redirect_to user_path(@user)
      flash[:notice] = '更新しました'
    else
      render "edit"
    end
  end

  def families
    @hospitals = @user.families
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, 
    :postal_code, :address, :telphone_number, :profile_image)
  end
end
