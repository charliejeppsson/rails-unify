class EventsController < ApplicationController
  before_action :set_event, only:[:show, :edit, :update, :destroy]
  before_action :require_login, only: [:new, :create, :attend]

  def index
    @events = Event.all
    # if params[:event].nil? || params[:event][:category].nil? || params[:event][:category] == ""
    #   @events = Event.all
    # else
    #   @category = params[:event][:category]
    #   @events = Event.where(category: @category)
    # end

    @hash = Gmaps4rails.build_markers(@events) do |event, marker|
      if event.latitude
        marker.lat event.latitude
        marker.lng event.longitude
      else
        marker.lat '29.978'
        marker.lng '31.1320'
        # CHANGE!
      end
    end
  end

  def show

    @alert_message = "You are viewing #{@event.title}"
    @event_coordinates = [@event]
    @hash = Gmaps4rails.build_markers(@event_coordinates) do |event, marker|
      if event.latitude
        marker.lat event.latitude
        marker.lng event.longitude
      else
        marker.lat '29.978'
        marker.lng '31.1320'
        # CHANGE!
      end
    end
  end

  def new
    @event = Event.new
  end

  def create
start_t = params[:event][:start_time]
end_t = params[:event][:end_time]

start_p =  DateTime.strptime(start_t, "%m/%d/%Y %H:%m %p")
end_p = DateTime.strptime(end_t, "%m/%d/%Y %H:%m %p")

    @event = Event.new(event_params)
    @event.start_time = start_p
    @event.end_time = end_p

    if @event.save
      redirect_to events_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    @event.update(event_params)
    @event.save
    redirect_to events_path
  end

  def destroy
    @event.destroy
    redirect_to events_path
  end

  def attend
    @event = Event.find(params[:event_id])
    @user = current_user

   if Attendance.exists?(user_id: @user.id, event_id: @event.id)
      redirect_to event_path(@event)
      flash[:alert] = "You are already checkin"
  elsif  #geoloc = true
        Attendance.create(user_id: @user.id, event_id: @event.id)
        redirect_to event_path(@event)
        flash[:notice] = "You have successfully checkin this event"
  else  redirect_to event_path(@event)
        flash[:notice] = "You can't check in as you are not in the zone"

  end

end


  private

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :start_time, :end_time, :organization, :category, :location, :user_id)
  end

  def require_login
    if !current_user
       flash[:alert] = "You need to sign in to do this action"
      redirect_to new_user_session_path
    end
  end
end
