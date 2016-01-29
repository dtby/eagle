# == Schema Information
#
# Table name: point_alarms
#
#  id            :integer          not null, primary key
#  pid           :integer
#  state         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  point_id      :integer
#  is_checked    :boolean          default(FALSE)
#  comment       :string(255)
#  room_id       :integer
#  device_id     :integer
#  sub_system_id :integer
#
# Indexes
#
#  index_point_alarms_on_device_id      (device_id)
#  index_point_alarms_on_point_id       (point_id)
#  index_point_alarms_on_room_id        (room_id)
#  index_point_alarms_on_sub_system_id  (sub_system_id)
#
# Foreign Keys
#
#  fk_rails_72669ae946  (room_id => rooms.id)
#  fk_rails_776a91d70e  (device_id => devices.id)
#  fk_rails_d8bc97a1a7  (sub_system_id => sub_systems.id)
#  fk_rails_de15df710f  (point_id => points.id)
#

require 'will_paginate/array'
class PointAlarmsController < BaseController

  before_action :authenticate_user!, only: [:checked, :unchecked], if: lambda { |controller| controller.request.format.html? }
  before_action :set_room, only: [:index, :modal, :update_multiple]
  before_action :set_point_alarm, only: [:checked, :unchecked, :modal, :update_multiple]
  acts_as_token_authentication_handler_for User, only: [:index, :checked, :unchecked, :modal, :update_multiple]

  def index

    if params[:sub_system].present?
      sub_system = SubSystem.find_by(name: params[:sub_system])
      devices = sub_system.patterns.map(&:devices).flatten
    else
      devices = @room.devices
    end

    return unless devices.present?
    point_alarms = devices.map(&:point_alarms).flatten

    if params[:checked].present? && params[:checked] == "0"
      @point_alarms = point_alarms.paginate(page: params[:page], per_page: 10)
    elsif params[:checked].present? && params[:checked] == "1"
      @point_alarms = point_alarms.where(is_checked: true).paginate(page: params[:page], per_page: 10)
    else
      @point_alarms = point_alarms.where(is_checked: false).paginate(page: params[:page], per_page: 10)
    end
  end

  def count
    # 子系统拥有的告警数、设备拥有的告警数
    @results = {}
    if params[:room_id].present? && !(params[:sub_system_id].present?)

      point_alarms = PointAlarm.where(room_id: params[:room_id])
      sub_system_ids = point_alarms.pluck(:sub_system_id)

      return unless sub_system_ids.present?
      sub_system_names = SubSystem.where(id: sub_system_ids.uniq).map(&:name)
      ids = sub_system_ids.uniq.collect { |ssi| sub_system_ids.count(ssi) }

      @results = Hash[sub_system_names.zip(ids)]
    elsif params[:sub_system_id].present?

      point_alarms = PointAlarm.where(sub_system_id: params[:sub_system_id])
      device_ids = point_alarms.pluck(:device_id)
      
      return unless device_ids.present?
      device_names = Device.where(id: device_ids.uniq).map(&:name)
      ids = device_ids.uniq.collect { |di| device_ids.count(di) }
      
      @results = Hash[device_names.zip(ids)]
    end
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

  def update_multiple
    if PointAlarm.where({id: params[:point_alarms]}).update_all(is_checked: true)
      flash[:notice] = "处理成功"
      return redirect_to alert_room_path(@room)
    else
      flash[:notice] = "处理失败"
      return redirect_to alert_room_path(@room)
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
