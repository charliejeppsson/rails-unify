class ContactsController < ApplicationController


  def index
    @user = current_user
  end

  def show

  end


  def edit

  end

  def update
    redirect_to contacts_path
  end

  def destroy
    @user_contact_id = params[:id]
    @contact = Contact.find_by(user_contact_id: @user_contact_id)
    @contact.destroy
    redirect_to contacts_path
  end
end
