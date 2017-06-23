class ContactsController < ApplicationController
  def new
  end

  def create
  end

  def index
  end

  def show
  end

  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy
    redirect_to contact_attendances_path
  end
end
