# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pattern_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :integer
#  pic_path   :string(255)
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#  index_devices_on_room_id     (room_id)
#
# Foreign Keys
#
#  fk_rails_2deefbda3a  (pattern_id => patterns.id)
#  fk_rails_3824183ebe  (room_id => rooms.id)
#

class DevicesController < BaseController
  before_action :authenticate_user!, if: lambda { |controller| controller.request.format.html? }
  acts_as_token_authentication_handler_for User, only: [:search]

  def index
    room = Room.where(id: params[:room_id]).first
    @devices = room.devices
  end

  def show
    if request.format.html?
      @room = Room.where(id: params[:room_id]).first
      @device = Device.includes(:points).where(id: params[:id]).first
      @alarms = Device.find(params[:id]).alarms.sort_by{|x| x.device_name.gsub(/[^0-9]/, '').to_i}
      @points = @device.points_value
      @exclude_points = @device.pattern.getting_exclude_points
      ##通过设备名称获取背景图片
      @attachment = @room.attachments.where("tag like ?", "%#{@device.name}%").first
    else
      @device = Device.find_by(id: params[:id])
      @points = @device.try(:points).try(:order, 'name').try(:to_a)
      @points = @points.sort_by {|p| p.name[/\d+/].to_i }
      @alarms, @alarm_types = @device.alarm_group
      #通过设备名称获取背景图片
      @attachment = @room.attachments.where("tag like ?", "%#{@device.name}%").first
    end
  end

  def refresh_data
    @room = Room.where(id: params[:room_id]).first
    @device = Device.includes(:points).where(id: params[:id]).first
    @alarms = Device.find(params[:id]).alarms.sort_by{|x| x.device_name.gsub(/[^0-9]/, '').to_i}
    @points = @device.points_value
    @exclude_points = @device.pattern.getting_exclude_points
    respond_to do |format|
      format.js {}
    end
  end

  def search
    @point_values = {}
    @device_alarm = {}
    if params[:sub_sys_name] == "烟感"
      @devices = Device.where(room_id: params[:room_id], name: "烟感")
      @devices.each do |device|
        @device_alarm[device.try(:id)] = device.is_alarm?
      end
      return
    end

    sub_system = SubSystem.find_by(name: params[:sub_sys_name])
    return unless sub_system.present?
    sub_sys_name = params[:sub_sys_name]    
    patterns = sub_system.try(:patterns)
    @devices = []
    
    if patterns.present?
      patterns.each do |pattern|
        devices = pattern.devices.where(room_id: params[:room_id])
        next unless devices.present?
        @devices.concat devices.includes(:points).where(room_id: params[:room_id])
        devices.each do |device|
          @point_values[device.try(:id)] = {}
          case sub_sys_name
          when "温湿度系统"
            points = device.try(:points)
            points.each do |point|
              @point_values[device.try(:id)][point.name] = (point.value || "0")
            end
          when "消防系统"
            points = device.try(:points)
            points.each do |point|
              @point_values[device.try(:id)][point.name] = point.try(:point_alarm).try(:state).to_s || "0"
            end
          when "空调系统"
            name = device.try(:name)
            if name.present? && ((name.include? "冷水机组") || (name.include? "室外机"))
              @device_alarm[device.try(:id)] = device.is_alarm?
              puts "#{device.id}, #{device.is_alarm?}"
            else
              ele_point_values device
            end
            con_point_values device
          when "配电系统"
            @device_alarm[device.try(:id)] = device.is_alarm?
          else
            ele_point_values device
          end
        end
      end
    end
    if @devices.present?
      result = true
      @devices.each { |device| result &&= (device.name =~ /\d+/) }
      if result
        @devices.sort_by! {|d| d.name[/\d+/].to_i }
      else
        @devices.sort_by! {|d| d.name }
      end
    end
  end



  # for 电
  def ele_point_values device
    point_ids = $redis.hget "eagle_key_points_value", device.id
    point_ids = point_ids.try(:split, "-")
    @point_values[device.try(:id)] = {}
    names = ["A相电压", "B相电压", "C相电压", "频率"]

    0.upto(3) do |index|
      @point_values[device.try(:id)][names[index]] = 
        Point.find_by(id: point_ids.try(:[], index).try(:to_i)).try(:value) || "0"
    end
  end

  # for 空调系统
  def con_point_values device
    point_ids = $redis.hget "eagle_key_points_value", device.id
    point_ids = point_ids.try(:split, "-")
    
    @point_values[device.try(:id)] = {}
    names = ["温度", "湿度"]
    
    0.upto(1) do |index|
      @point_values[device.try(:id)][names[index]] = 
        Point.find_by(id: point_ids.try(:[], index).try(:to_i)).try(:value) || "0"
    end
  end


  private

    def get_point_names sub_sys_name
      # 动力系统 ->  配电系统 -> 配电柜  "A相电压" "B相电压" "C相电压" "电流"
      # 动力系统 ->  UPS系统 -> UPS1  "A相电压" "B相电压" "C相电压" "电流"
      # 动力系统 ->  列头柜 -> 列头柜1  "工作正常"
      # 动力系统 ->  电池检测 -> 电池组1  "总电压" "总电流" "温度1" "温度2"
      point_names = []
      case sub_sys_name
      when "配电系统"
        point_names = "输出电压"
      when "UPS系统"
        point_names = "输出电压"
      when "列头柜"
        point_names = ["工作正常"]
      when "电池检测"
        point_names = ["总电压", "总电流", "温度1", "温度2"]
      end
      point_names
    end

end
