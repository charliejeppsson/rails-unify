class ContactsController < ApplicationController


  def index

    if params.has_key?(:search_value) and params[:search_value] !=""
      search = params[:search_value]
      @result = Contact.global_search(search)
    else

      @user = current_user
    end
  end

  def show
    @contact = Contact.find(params[:contact_id])
    @user = User.find(params[:id])
  end


  def edit
respond_to do |format|
  format.js {render layout: false} # Add this line to you respond_to block
end
  end

  def destroy
    @user_contact_id = params[:id]
    @contact = Contact.find_by(user_contact_id: @user_contact_id)
    @contact.destroy
    redirect_to contacts_path
  end

  def update
    @contact = Contact.find(params[:contact_id])
    @user = User.find(params[:id])
    @contact.update(contact_details)
     respond_to do |format|
          format.html { redirect_to user_path(@user) }
          format.js { @contact }  # <-- will render `app/views/reviews/create.js.erb`
        end
  end



  private

  def contact_details
    params.require(:contact).permit(:notes, :category)
  end

end
