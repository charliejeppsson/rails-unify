class PagesController < ApplicationController

  def home
     @user = User.new
    @event = Event.new
  end
end
