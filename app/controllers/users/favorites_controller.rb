class Users::FavoritesController < ApplicationController
  def create
    @daily_record = DailyRecord.find(params[:daily_record_id])
    @favorite = current_user.favorites.new(daily_record_id: @daily_record.id)
    @favorite.save
  end

  def destroy
    @daily_record = DailyRecord.find(params[:daily_record_id])
    favorite = current_user.favorites.find_by(daily_record_id: @daily_record.id)
    favorite.destroy
  end
end
