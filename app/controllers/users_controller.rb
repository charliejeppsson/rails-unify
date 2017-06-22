class UsersController < ApplicationController
  # Controller created to generate a profile page
  def show
    @user = User.find(params[:id])
    # session[:search_results] = params[:event_id]
    # if current_user.attendances.include?(@event) && @user.attendances.include?(@event)
    #   @user.is_public = true
    # end
  end
end
