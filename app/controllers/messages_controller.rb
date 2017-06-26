class MessagesController < ApplicationController

  def create
    message = Message.new(message_params)
    message.user = current_user
    if message.save
      ActionCable.server.broadcast 'messages',
        message: message.to_json,
        user: message.user.to_json
      head :ok
    end
  end


  private

    def message_params
      params.require(:message).permit(:content, :chatroom_id)
    end

end
