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
    my_chats = current_user.chatrooms.map(&:id) + User.find(params[:with_user_id]).chatrooms.map(&:id)
    my_chats = my_chats.flatten.uniq

    chatroomuser = Chatroomuser.where(user_id: params[:with_user_id], chatroom_id: my_chats).first

    if chatroomuser
      @chatroom = chatroomuser.chatroom
    else
      # PREVIOUS CODE
      @chatroom = Chatroom.new
      @chatroom.user = current_user
      @chatroom.save

      Chatroomuser.create(user: current_user, chatroom: @chatroom)
      Chatroomuser.create(user_id: params[:with_user_id], chatroom: @chatroom)
      # / PREVIOUS CODE
    end

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
