class ChatsController < ApplicationController
  def create
    @chat = Chat.new(chat_params)
    @chat.save!
    @room = Room.find(params[:chat][:room_id])
    @chats = @room.chats
  end

  def show
    @room = Room.find(params[:room_id])
    @user = User.find(params[:user_id])
    @hospital = Hospital.find(params[:hospital_id])
    @chats = @room.chats
    @chat = Chat.new
  end

  def chat_params
    params.require(:chat).permit(:message, :room_id, :user_id, :hospital_id)
  end
end
