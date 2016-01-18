# == Schema Information
#
# Table name: point_alarms
#
#  id         :integer          not null, primary key
#  pid        :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  point_id   :integer
#  is_checked :boolean          default(FALSE)
#  comment    :string(255)
#  room_id    :integer
#
# Indexes
#
#  index_point_alarms_on_point_id  (point_id)
#  index_point_alarms_on_room_id   (room_id)
#
# Foreign Keys
#
#  fk_rails_72669ae946  (room_id => rooms.id)
#  fk_rails_de15df710f  (point_id => points.id)
#

require 'will_paginate/array'
class PointAlarmsController < BaseController

  before_action :authenticate_user!, only: [:checked, :unchecked], if: lambda { |controller| controller.request.format.html? }

  before_action :set_room, only: [:index, :modal]
  before_action :set_point_alarm, only: [:checked, :unchecked, :modal]
  acts_as_token_authentication_handler_for User, only: [:index, :checked, :unchecked, :modal]

  def index
    @point_alarms = @room.devices.map { |device| device.points.map { |point| point.point_alarm } }.flatten.paginate(page: params[:page], per_page: 10)
  end

  def checked
    if @point_alarm.update(is_checked: true)
      result = "处理成功"
    else
      result = "处理失败"
    end

    if request.format.html?
      @room = Room.find(params[:id])
      flash[:notice] = result
      return redirect_to alert_room_path(@room)
    else
      return render json: { result: result }
    end

  end

  def unchecked
    if @point_alarm.update(is_checked: false)
      result = "处理成功"
    else
      result = "处理失败"
    end

    if request.format.html?
      flash[:notice] = result
      return redirect_to alert_room_path(@room)
    else
      return render json: { result: result }
    end
  end

  # ajax模态框
  def modal
    respond_to do |format|
      format.js
    end
  end

  private
  def set_point_alarm
    @point_alarm = PointAlarm.find_by(point_id: params[:point_id] || params[:id])
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end
end
