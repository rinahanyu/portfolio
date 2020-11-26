class Users::HealthCaresController < ApplicationController
  before_action :set_health_care, only: [:edit, :update, :destroy]

  def new
    @health_care = HealthCare.new
  end

  def create
    @health_care = HealthCare.new(health_care_params)
    @health_care.user_id = current_user.id
    if @health_care.save
      redirect_to user_health_cares_path(current_user)
    else
      render "new"
    end
  end

  def index
    @user = User.find(params[:user_id])
    @health_cares = @user.health_cares.order(date: :desc)
  end

  def edit
  end

  def update
    if @health_care.update(health_care_params)
      redirect_to user_health_cares_path(current_user)
    else
      render "edit"
    end
  end

  def destroy
    @health_care.destroy
    redirect_to user_health_cares_path(current_user)
  end

  private
  def set_health_care
    @health_care = HealthCare.find(params[:id])
  end

  def health_care_params
    params.require(:health_care).permit(:body_weight, :max_blood_pressure, :min_blood_pressure, :blood_sugar, :date)
  end
end
