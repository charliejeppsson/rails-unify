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

    start_p =  DateTime.strptime(start_t, "%m/%d/%Y %H:%M %p")
    end_p = DateTime.strptime(end_t, "%m/%d/%Y %H:%M %p")

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
    # @event_nearby = Event.near([@event.latitude, @event.longitude], 0.1).first
    current_location_latitude = current_location["latitude"].to_f
    current_location_longitude = current_location["longitude"].to_f
    center_point = [current_location_latitude, current_location_longitude]
    box = Geocoder::Calculations.bounding_box(center_point, 1)
    #center_point_event = [@event.longitude, @event.latitude]

   if Attendance.exists?(user_id: @user.id, event_id: @event.id)
      redirect_to event_path(@event)
      flash[:alert] = "You are already checkin"
  elsif Event.within_bounding_box(box).first
        Attendance.create(user_id: @user.id, event_id: @event.id)
        redirect_to event_path(@event)
        flash[:notice] = "You have successfully checkin this event"
  else  redirect_to event_path(@event)
        flash[:alert] = "You can't check in as you are not in the zone"
  end

end

  def search
    @event = Event.new
    # if there is no search parameter
    if params[:event].nil?
      @events = Event.all
    end

    # if category
    unless params[:event].nil? || params[:event][:category].blank?
      tags_list = params[:event][:category].select { |i| i.present? }
      @events = Event.where("category ILIKE ?",tags_list[0])
    end

    # if location
    unless params[:event].nil? || params[:event][:location].blank?
      @category = params[:event][:category]
      @location = params[:event][:location]

      q2 = "%#{@location}%"

      @events = Event.where("location ILIKE ?", q2)

        # if @location == ""
        #   @events = Event.where(location: @location)
        # else
        #   @events = Event.where(category: @category)
        # end
    end

    render :index

      # if a parameter doesn't correspond to anything - add a note
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
