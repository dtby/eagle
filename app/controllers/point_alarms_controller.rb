require 'will_paginate/array'
class PointAlarmsController < BaseController
  before_action :authenticate_user!, only: [:checked, :unchecked]

  before_action :set_room
  before_action :set_point_alarm, only: [:checked, :unchecked]
  acts_as_token_authentication_handler_for User, only: [:index]

  def index
    @point_alarms = @room.devices.map { |device| device.points.map { |point| point.point_alarm } }.flatten.paginate(page: params[:page], per_page: 10)
  end

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
