class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
      @user_id = current_user_id


  end

  def index
  end

  def show
  end

  def destroy
  end
end
