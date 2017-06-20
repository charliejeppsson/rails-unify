class AttendancesController < ApplicationController
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
