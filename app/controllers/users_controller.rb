class UsersController < ApplicationController
  # Controller created to generate a profile page
  def show
    @user = User.find(params[:id])
  end
end
