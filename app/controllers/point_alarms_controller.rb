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
#  comment       :string(255)
#  room_id       :integer
#  device_id     :integer
#  sub_system_id :integer
#  alarm_value   :string(255)
#  checked_at    :datetime
#  checked_user  :string(255)
#  is_checked    :boolean
#  alarm_type    :string(255)
#  reported_at   :datetime
#  cleared_at    :datetime
#  meaning       :string(255)
#  is_cleared    :boolean
#  device_name   :string(255)
#
# Indexes
#
#  index_point_alarms_on_device_id      (device_id)
#  index_point_alarms_on_point_id       (point_id)
#  index_point_alarms_on_room_id        (room_id)
#  index_point_alarms_on_sub_system_id  (sub_system_id)
#

require 'will_paginate/array'
class PointAlarmsController < BaseController

  before_action :authenticate_user!, only: [:checked, :unchecked], if: lambda { |controller| controller.request.format.html? }
  before_action :set_room, only: [:index, :modal, :update_multiple]
  before_action :set_point_alarm, only: [:checked, :unchecked, :modal, :update_multiple]
  acts_as_token_authentication_handler_for User, only: [:index, :checked, :unchecked, :modal, :update_multiple]


  def create
    # :point_index, :time, :status, :alarm_value, :alarm_type, :point_type
    @errors = ""
    # permit_ips = ["127.0.0.1".freeze].freeze
    # unless permit_ips.include? request.remote_ip
    #   @error_code = 10001
    #   @errors = "没有权限！"
    #   return
    # end
    
    point = Point.find_by(point_index: params[:point_index])
    unless point.present?
      @error_code = 10002
      @errors = "没有找到该告警对应的点！"
      return
    end
    point_alarm = PointAlarm.find_or_create_by(point: point)

    infos = params.merge(point_id: point.id)
    result = point_alarm.update_info infos

    if result
      @errors = "数据更新成功！"
      @error_code = 0
    else
      @errors = "数据更新失败！" 
      @error_code = 10003
    end

  end

  def index
    _point_alarms = point_alarm_relations params

    _page = params[:page] || 1
    _per_page = params[:per_page] || 10

    _checked = params[:checked] || 2
    if _checked == 0
      @point_alarms = _point_alarms.paginate(page: _page, per_page: _per_page)
    elsif _checked == 1
      @point_alarms = _point_alarms.checked.paginate(page: _page, per_page: _per_page)
    else
      @point_alarms = _point_alarms.active.uncheck_or_one_day_checked.paginate(page: _page, per_page: _per_page)
    end
  end

  def show
    @point_alarm = PointAlarm.find_by(id: params[:id])
  end

  # 统计这个房间的告警数量
  def count
    if params[:room_id].present?
      _point_alarms = PointAlarm.where(room_id: params[:room_id]).active.uncheck_or_one_day_checked
      @room_count = _point_alarms.count
      _group_count_hash = _point_alarms.group(:sub_system_id).count
      @sub_system_count_hash = _group_count_hash.each_with_object({}) do |(id, count), o|
        o[SubSystem.find_by(id: id)] = count if id.present?
      end
    end
  end

  def checked
    puts "#{@point_alarm.inspect}"
    if @point_alarm.present? && @point_alarm.update(checked_at: DateTime.now, is_checked: true)
      @point_alarm.check_alarm_by_user(current_user.name)
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
    if @point_alarm.present? && @point_alarm.update(is_checked: false)
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
    @point_alarm = (PointAlarm.find_by(point_id: params[:point_id]) || PointAlarm.find_by(id: params[:id]))
  end

  def point_alarm_relations params
    # 单个设备的告警
    if params[:device_id].present?
      _point_alarms = PointAlarm.where(device_id: params[:device_id])
    # 单个sub system的告警
    elsif params[:sub_system_id].present?
      _point_alarms = PointAlarm.where(room_id: params[:room_id], sub_system_id: params[:sub_system_id])
    # 单个room的告警
    else
      _point_alarms = PointAlarm.where(room_id: params[:room_id])
    end
    _point_alarms
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end
end
