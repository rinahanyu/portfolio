class  Users::MedicalHistoriesController < ApplicationController
  before_action :set_medical_history, only: [:edit, :update, :destroy]

  def new
    @medical_history = MedicalHistory.new
  end

  def create
    @medical_history = MedicalHistory.new(medical_history_params)
    @medical_history.user_id = current_user.id
    if @medical_history.save
      redirect_to user_medical_histories_path(current_user)
      flash[:notice] = '投稿しました'
    else
      render "new"
    end
  end

  def index
    @user = User.find(params[:user_id])
    @medical_histories = @user.medical_histories.order(started_on: :desc)
    respond_to do |format|
      format.html do
      end
      format.csv do
        send_data render_to_string, filename: "病歴.csv", type: :csv
      end
    end
  end

  def edit
  end

  def update
    if @medical_history.update(medical_history_params)
      redirect_to user_medical_histories_path(current_user)
      flash[:notice] = '更新しました'
    else
      render "edit"
    end
  end

  def destroy
    @medical_history.destroy
    redirect_to user_medical_histories_path(current_user)
    flash[:alert] = '削除しました'
  end

  private
  def set_medical_history
    @medical_history = MedicalHistory.find(params[:id])
  end

  def medical_history_params
    params.require(:medical_history).permit(:disease, :started_on, :finished_on, :treatment, :hospital)
  end
end
