class AttendancesController < ApplicationController
  def dashboard
    @organized_events = current_user.events.order(start_time: :asc).select{|event| event.start_time > Time.now }
    @events = current_user.events_to_attend.order(start_time: :asc).select{|event| event.start_time > Time.now }
    @user = current_user
  end

  def destroy
    # @user = current_user
    # @events = current_user.events_to_attend.order(start_time: :asc).select{|event| event.start_time > Time.now }
    # @events.each do |event|
    #   @attendance = current_user.attendances.where(event: event).first
    #   unless @attendance.nil?
    #   @attendance.destroy
    #
    #   end
    # end
    @attendance = Attendance.find(params[:id])
    @attendance.destroy
    redirect_to dashboard_attendances_path
  end
end
