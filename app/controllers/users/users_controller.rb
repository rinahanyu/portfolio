class Users::UsersController < ApplicationController
  before_action :set_user

  def show
    @daily_records = @user.daily_records.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
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
    params.require(:user).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :postal_code, :address, :telphone_number, :profile_image)
  end
end
