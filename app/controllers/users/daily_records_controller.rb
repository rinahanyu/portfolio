class Users::DailyRecordsController < ApplicationController
  before_action :set_daily_record, only: [:show, :edit, :update, :destroy]

  def new
    @daily_record = DailyRecord.new
  end

  def create
    @daily_record = DailyRecord.new(daily_record_params)
    @daily_record.user_id = current_user.id
    if @daily_record.save
      redirect_to user_path(current_user)
      flash[:notice] = '投稿しました'
    else
      render "new"
    end
  end

  def index
    @daily_records = DailyRecord.all.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
    @daily_record = DailyRecord.find(params[:id])
  end

  def edit
  end

  def update
    if @daily_record.update(daily_record_params)
      redirect_to daily_record_path(@daily_record)
      flash[:notice] = '更新しました'
    else
      render "edit"
    end
  end

  def destroy
    @daily_record.destroy
    redirect_to user_path(current_user)
    flash[:alert] = '削除しました'
  end

  def search
    @daily_records = DailyRecord.where(genre: params[:genre])
  end

  private
  def set_daily_record
    @daily_record = DailyRecord.find(params[:id])
  end

  def daily_record_params
    params.require(:daily_record).permit(:theme, :introduction, :daily_image, :genre)
  end
end
