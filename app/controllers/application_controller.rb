class ApplicationController < ActionController::Base
  # 患者本人かどうか（user_id）
  def correct_user_id
    @user = User.find(params[:user_id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  # 患者本人かどうか(id)
  def correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  # 医療機関本人かどうか
  def correct_hospital
    @hospital = Hospital.find(params[:id])
    unless @hospital == current_hospital
      redirect_to hospital_path(current_hospital)
    end
  end

  # 該当患者を持つ医療機関かどうか(user_id)
  def family_hospital_id
    @user = User.find(params[:user_id])
    unless current_hospital.patients?(@user)
      redirect_to hospital_path(current_hospital)
    end
  end

  # ログインしている患者もしくは医療機関かどうか
  def all_signed_in
    if !user_signed_in? && !hospital_signed_in?
      redirect_to root_path
    end
  end

  # 日常記録の正しい投稿者かどうか
  def correct_daily_record_user
    @daily_record = DailyRecord.find(params[:id])
    unless @daily_record.user_id == current_user.id
      redirect_to user_path(current_user)
    end
  end

  # ログインしている患者本人もしくはかかりつけ医の医療機関かどうか(user_id)
  def correct_relationship_id
    @user = User.find(params[:user_id])
    if !user_signed_in? && !hospital_signed_in?
      redirect_to root_path
    elsif current_user.present? && current_user != @user
      redirect_to user_path(current_user)
    elsif current_hospital.present? && !current_hospital.patients?(@user)
      redirect_to hospital_path(current_hospital)
    end
  end

  # ログインしている患者本人もしくはかかりつけ医の医療機関かどうか(id)
  def correct_relationship
    @user = User.find(params[:id])
    if !user_signed_in? && !hospital_signed_in?
      redirect_to root_path
    elsif current_user.present? && current_user != @user
      redirect_to user_path(current_user)
    elsif current_hospital.present? && !current_hospital.patients?(@user)
      redirect_to hospital_path(current_hospital)
    end
  end
end
