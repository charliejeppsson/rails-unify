class UsersController < ApplicationController
  # Controller created to generate a profile page
  def show
    @user = User.find(params[:id])
    @contact =  Contact.where(user_id: current_user.id, user_contact_id: @user.id).first
  end

end
