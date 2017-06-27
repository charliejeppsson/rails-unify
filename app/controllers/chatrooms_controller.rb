class ChatroomsController < ApplicationController
  def index
    @chatrooms = Chatroom.all
  end

  def show
    # @chatroom = Chatroom.find_by(slug: params[:slug])
    @chatroom = Chatroom.find(params[:id])
    @message = Message.new
  end

  def new
    @chatroom = Chatroom.new
    @chatroom.user = current_user
    @chatroom.save

    Chatroomuser.create(user: current_user, chatroom: @chatroom)
    Chatroomuser.create(user_id: params[:with_user_id], chatroom: @chatroom)

    redirect_to chatroom_path(@chatroom)

  end

  def create
    # @chatroom = current_user.chatrooms.build(chatroom_params)
    @chatroom = Chatroom.new(chatroom_params)
    if @chatroom.save
      flash[:success] = 'New conversation started!'
      redirect_to chatrooms_path
    else
      render 'new'
    end
  end

  private

  def chatroom_params
    params.require(:chatroom).permit(:user_id)
  end
end
