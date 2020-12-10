class Users::CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @daily_record = DailyRecord.find(params[:daily_record_id])
    comment = current_user.comments.new(comment_params)
    comment.daily_record_id = @daily_record.id
    comment.save
  end

  def destroy
    @daily_record = DailyRecord.find(params[:daily_record_id])
    Comment.find_by(id: params[:id], daily_record_id: params[:daily_record_id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)
  end
end
