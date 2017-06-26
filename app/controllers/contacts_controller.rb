class ContactsController < ApplicationController


  def index
    @user = current_user
  end

  def show

  end


  def edit

  end

  def update

  end

  def destroy

    @user_contact_id = params[:user_contact_id]
    @contact = Contact.find_by(user_contact_id: @user_contact_id)
    @contact.destroy
    redirect_to contacts_index_path
  end
end
