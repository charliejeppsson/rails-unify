class AttendancesController < ApplicationController
   before_action :require_login, only: [:dashboard]
   #add before_action event.save control (user_id: @user.id, event_id: @event.id) doesn't exist

  def dashboard
    @myattendances = Attendance.where(user_id: current_user.id)
    @user = current_user
  end

  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.destroy
    redirect_to dashboard_attendances_path
  end
end


