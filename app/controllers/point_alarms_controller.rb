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
#  alarm_type    :integer
#  alarm_value   :string(255)
#  checked_at    :datetime
#  checked_user  :string(255)
#  is_checked    :boolean
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
    
    point = Point.unscoped.find_by(point_index: params[:point_index])
    point.update(state: true) unless point.state
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
    if (params[:sub_system].present?) && (!params[:id].present?)
      sub_system = SubSystem.find_by(name: params[:sub_system])
      return unless sub_system.present?
      devices = sub_system.patterns.map(&:devices).flatten
      return unless devices.present?
      point_alarms = devices.map(&:point_alarms).flatten
      point_alarms = point_alarms.select { |point_alarm| params[:room_id].to_i == point_alarm.room_id } 
    elsif (!params[:sub_system].present?) && (params[:id].present?)
      device = Device.find_by(id: params[:id])
      point_alarms = device.try(:point_alarms).to_a
    else
      point_alarms = PointAlarm.where(room_id: params[:room_id]).to_a
    end
    
    return unless point_alarms.present?
    point_alarms.select! { |pas| (pas.state != 0) && 
      (((1.day.ago..DateTime.now).cover? pas.checked_at) || pas.checked_at.blank?) }

    page = (params[:page].to_i < 1) ? 1 : params[:page]
    if params[:checked].present? && params[:checked] == "0"
      point_alarms = point_alarms
    elsif params[:checked].present? && params[:checked] == "1"
      point_alarms = point_alarms.select{ |pa| pa.is_checked }
    else
      point_alarms = point_alarms.select{ |pa| (!pa.is_checked) }
    end
    @point_alarms = point_alarms.sort_by {|p| p.point.name[/\d+/].to_i }.paginate(page: page, per_page: (params[:per_page] || 10))
  end

  def show
    @point_alarm = PointAlarm.find_by(id: params[:id])
  end

  def count
    # 子系统拥有的告警数、设备拥有的告警数
    @results = {}
    if params[:room_id].present? && !(params[:sub_system_id].present?)
      
      point_alarms = 
        PointAlarm.is_warning_alarm.where(
          room_id: params[:room_id]).try(:to_a)
      return unless point_alarms.present?

      point_alarms.select! { |pa| ((1.day.ago..DateTime.now).cover? pa.checked_at) || pa.checked_at.blank? }
      sub_system_ids = point_alarms.collect { |pa| pa.sub_system_id }.compact

      return unless sub_system_ids.present?
      ids = sub_system_ids.uniq
      sub_system_names = []
      Array(ids).each do |id|
        sub_system_names << SubSystem.find(id).try(:name)
      end
      ids = sub_system_ids.uniq.collect { |ssi| sub_system_ids.count(ssi) }

      @results = Hash[sub_system_names.zip(ids)]
    elsif params[:sub_system_id].present?

      # point_alarms = PointAlarm.where("room_id = #{params[:room_id]} AND sub_system_id = #{params[:sub_system_id]} AND (state != 0 OR checked_at BETWEEN '#{1.day.ago.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{DateTime.now.strftime("%y-%m-%d %H:%M:%S")}')")
      point_alarms = 
        PointAlarm.is_warning_alarm.where(
          room_id: params[:room_id]).try(:to_a)
      return unless point_alarms.present?

      point_alarms.select! { |pa| 
        ((1.day.ago..DateTime.now).cover? pa.checked_at) || pa.checked_at.blank? 
      }
   
      device_ids = point_alarms.collect { |pa| pa.device_id }.compact

      return unless device_ids.present?
      ids = device_ids.uniq
      device_names = []
      Array(ids).each do |id|
        device_names << Device.find(id).try(:name)
      end
      ids = device_ids.uniq.collect { |di| device_ids.count(di) }
      
      @results = Hash[device_names.zip(ids)]
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

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end
end
