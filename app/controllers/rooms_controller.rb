class RoomsController < ApplicationController
  def create
    @room = Room.create(room_params)
    redirect_to chat_path(@room, hospital_id: params[:room][:hospital_id], user_id: params[:room][:user_id])
  end

  def room_params
    params.require(:room).permit(:hospital_id, :user_id)
  end
end
