class PointAlarmsController < BaseController
  before_action :set_room
  before_action :set_point_alarm

  def checked
    if @point_alarm.update(is_checked: true)
      flash[:notice] = "处理成功"
      return redirect_to alert_room_path(@room)
    else
      flash[:notice] = "处理失败"
      return redirect_to alert_room_path(@room)
    end
  end

  def unchecked
    if @point_alarm.update(is_checked: false)
      flash[:notice] = "处理成功"
      return redirect_to alert_room_path(@room)
    else
      flash[:notice] = "处理失败"
      return redirect_to alert_room_path(@room)
    end
  end

  private
  def set_point_alarm
    @point_alarm = PointAlarm.find_by(point_id: params[:point_id])
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end
end