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
      @points = @device.points_group
      @exclude_points = @device.pattern.getting_exclude_points
    else
      @device = Device.find_by(id: params[:id])
      @points = @device.try(:points)
    end
  end

  def search
    
    sub_system = SubSystem.find_by(name: params[:sub_sys_name])
    return unless sub_system.present?
    names = ["A相电压", "B相电压", "C相电压", "频率"]
    sub_sys_name = params[:sub_sys_name]
    @point_values = {}
    

    patterns = sub_system.try(:patterns)
    @devices = []
    
    if patterns.present?
      patterns.each do |pattern|
        devices = pattern.devices
        next unless devices.present?
        @devices.concat devices.includes(:points).where(room_id: params[:room_id])
        devices.each do |device|
          @point_values[device.try(:id)] = {}
          point_ids = $redis.hget "eagle_key_points_value", device.id
          
          next unless point_ids.present?
          point_ids.split("-").each_with_index do |point_id, index| 
            point = Point.find_by(id:point_id.to_i)
            @point_values[device.try(:id)][names[index]] = point.try(:value) || 0
          end
        end
      end
    end
    logger.info "@point_values is #{@point_values.inspect}"
    puts "@point_values is #{@point_values.inspect}"
    # points = device.points
    # next unless points.present?

    # json.points points.each do |point|
    #   json.point_id point.id
    #   if point.name.include? "-"
    #     json.point_name point.name.split("-").last
    #   else
    #     json.point_name point.name
    #   end
    #   json.point_value point.value
    # end
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