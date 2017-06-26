class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.all
  end

  def show
    # @chatroom = Chatroom.find_by(slug: params[:slug])
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end
end
