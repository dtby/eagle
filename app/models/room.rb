# == Schema Information
#
# Table name: rooms
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  link         :string(255)
#  monitor_link :string(255)
#

class Room < ActiveRecord::Base

  validates_presence_of :name#, :link
  validates_uniqueness_of :name

  has_many :menus, dependent: :destroy
  has_many :systems, source: 'menuable', source_type: 'System', through: :menus
  has_many :sub_systems, source: 'menuable', source_type: 'SubSystem', through: :menus
  has_many :user_rooms, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :users, through: :user_rooms

  has_many :devices, dependent: :destroy
  has_many :point_alarms, dependent: :destroy

  def pic
    path = Attachment.find_by("tag like ? AND room_id = ?", "%主图%", id).try(:image_url)
    "#{ActionController::Base.asset_host}#{path}" if path.present?
  end
  # Room.get_computer_room_list
  def self.get_computer_room_list
    start_time = DateTime.now.strftime("%Q").to_i
    # 名字-> [{系统 -> 设备}, ... {系统 -> 设备}]
    point_hash = {}
    datas_to_hash AnalogPoint, point_hash
    generate_system point_hash, "analog"

    point_hash = {}
    datas_to_hash DigitalPoint, point_hash
    generate_system point_hash, "digital"

    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "Room.get_computer_room_list time is #{end_time-start_time}"
  end

  # Room.generate_point_value
  def self.generate_point_value
    start_time = DateTime.now.strftime("%Q").to_i
    PointState.all.each do |point_state|
      p = Point.digital.find_by(point_index: point_state.try(:pid))
      $redis.hset "eagle_point_value", point_state.try(:pid), (p.try(:meaning) || point_state.try(:value))
    end
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "Room.generate_point_value time is #{end_time-start_time}"
  end

  # Room.generate_value_meaning
  def self.generate_value_meaning
    DigitalPoint.all.each do |dp|
      next if (dp.OffName.blank? || dp.OnName.blank?)
      $redis.hset "eagle_value_meaning", dp.try(:PointID), [dp.OffName, dp.OnName].join("-") 
    end

    AnalogPoint.all.each do |ap|
      next if ap.UpName.blank? || ap.UUpName.blank? || ap.DnName.blank? || ap.DDnName.blank?
      $redis.hset "eagle_value_meaning", ap.try(:PointID), [ap.DDnName, ap.DnName, ap.UpName, ap.UUpName].join("-") 
    end
    nil
  end

  def self.generate_system  point_hash, type
    # 机房 => { 系统 => 子系统 => { 点 => 数据 }
    point_hash.each do |room, system_hash|
      room = Room.find_or_create_by(name: room)
      system_hash.each do |sub_name, patterns|
        sub_name, pattern_name = sub_name.split("-")
        # puts "sub_name is #{sub_name}, pattern_name is #{pattern_name}"
        sub_name.delete! "普通" if sub_name.present? && (sub_name.include? "普通")
        pattern_name = "普通温湿度" if pattern_name == "th802"

        next if pattern_name.blank?
        
        sub_system = SubSystem.find_or_create_by(name: sub_name)
        patterns.each do | name, points|
          pattern = Pattern.find_or_create_by(sub_system_id: sub_system.id, name: pattern_name.try(:strip))
          name = "温湿度" if name.try(:include?, "温湿度")
          device = Device.find_or_create_by(name: name, pattern: pattern, room: room)
          points.each do |name, value|
            point_index, max, min = value.split("!")
            p = Point.unscoped.find_or_create_by(name: name, device: device, point_index: point_index)
            p.update(point_type: type) unless p.point_type
            p.update(max_value: max, min_value: min) if (max && min)
            p.update(state: true, updated_at: DateTime.now)
            check_point sub_name, name, p.id, device.id
          end
        end
      end
    end
    Point.where(updated_at: DateTime.new(2010,1,1)..15.minute.ago).update_all(state: false)
    nil
  end


  def self.check_point sub_sys_name, point_name, point_id, device_id
    # 动力系统 ->  配电系统 -> 配电柜  "A相电压" "B相电压" "C相电压" "电流"
    # 动力系统 ->  UPS系统 -> UPS1  "A相电压" "B相电压" "C相电压" "电流"
    # 动力系统 ->  列头柜 -> 列头柜1  "工作正常"
    # 动力系统 ->  电池检测 -> 电池组1  "总电压" "总电流" "温度1" "温度2"
    case sub_sys_name
    when "UPS系统", "配电系统"
      # 文档： "UPS系统", "配电系统"，“输出电压ABC表示”
      if point_name == "频率"
        point_name = "输出电压D"
        result = 0
      else
        result = point_name =~ /输出电压([A-Z])/
      end

      return if result.nil?
      point_ids = ($redis.hget "eagle_key_points_value", device_id) || [0,0,0,0].join("-")
      unless point_ids.present?
        $redis.hset "eagle_key_points_value", device_id, [0,0,0,0].join("-")
      end
      index = get_index point_name, result, 4

    when "列头柜"
      # result = (point_name == "工作正常")
      # return if result.nil?
    when "电池检测"
      # result = (["总电压", "总电流", "温度1", "温度2"].include? point_name)
      # return if result.nil?
    when "空调系统"
      point_ids = ($redis.hget "eagle_key_points_value", device_id)
      unless point_ids.present?
        point_ids = [0,0].join("-")
        $redis.hset "eagle_key_points_value", device_id, point_ids
      end

      if point_name.include? "温度测量值"
        index = 0
      elsif point_name.include? "湿度测量值"
        index = 1
      else
        return
      end
    when "电量仪系统"
      if point_name == "系统-频率"
        point_name = "D相电压"
        result = 0
      else
        result = (point_name =~ /-([A-Z])相电压/)
        result += 1 if result
      end

      return if result.nil?
      
      point_ids = ($redis.hget "eagle_key_points_value", device_id) || [0,0,0,0].join("-")
      unless point_ids.present?
        $redis.hset "eagle_key_points_value", device_id, [0,0,0,0].join("-")
      end
      index = get_index point_name, result
    else
      return
    end
 
    point_ids = point_ids.split("-")
    return if point_ids[index] == point_id
    point_ids[index] = point_id
    $redis.hset "eagle_key_points_value", device_id, point_ids.join("-")
    nil
  end

  def self.get_index point_name, index, offset = 0
    point_name[index+offset].ord - "A".ord
  end

  def self.datas_to_hash class_name, group_hash
    class_name.all.each do |ap|
      # BayName: 机房A-配电系统
      # 机房A -> 配电系统 -> 配电柜 -> 
      bay_info = ap.BayName.upcase.split("-")

      device_name = bay_info.second
      point_name = ap.PointName.upcase

      if bay_info.second.present? && (/\d+机柜/ =~ bay_info.second)
        index = bay_info.second.index "机柜"
        line = bay_info.second[index+2..-1]

        point_name.prepend bay_info.second[0..index-1]
        point_name += line

        device_name = bay_info.second[0] + "机柜"  # C机柜
      end

      group_hash[bay_info.first] = {} unless group_hash[bay_info.first].present?
      group_hash[bay_info.first][ap.GroupName] = {} unless group_hash[bay_info.first][ap.GroupName].present?
      # puts "bay_info is #{bay_info}"
      
      point_hash = {}
      group_hash[bay_info.first][ap.GroupName][device_name] = {} unless group_hash[bay_info.first][ap.GroupName][device_name].present?
      group_hash[bay_info.first][ap.GroupName][device_name][point_name] = "#{ap.PointID}!#{ap.try(:UpValue)}!#{ap.try(:DnValue)}"
    end
    group_hash
  end

  

  # Room.generate_alarm_data
  def self.generate_alarm_data
    start_time = DateTime.now.strftime("%Q").to_i
    aps = AnalogPoint.where('PointName=? or PointName=?', '电流有效值', '电压有效值')
    ap_names = aps.pluck(:BayName).uniq

    
    ap_names.each_with_index do |name, index|
      puts "index is #{index}"
      points = aps.where(BayName: name)
      device_name = name.split("-").last

      line = ""
      device_info = ""

      if /\d+机柜/ =~ device_name
        index = device_name.index "机柜"
        line = device_name[index+2..-1]
        device_info = device_name[0..index-1]
        device_name = device_name[0] + "机柜"
      end

      device = Device.find_or_create_by(name: device_name)
      alarm = Alarm.find_or_create_by(device_name: (name.split("-").last.remove line), device_id: device.try(:id))
      points.each_with_index do |point, index|
        ps = PointState.where(pid: point.PointID).first
        # puts "value is #{ps.value}, name is #{name}"
        # C11视在功率A路
        point_name = device_info + point.PointName+line
        puts "point_name is #{point_name}, PN is #{point.PointName}, line is #{line}, point_name is #{point_name[-7..-1]}" if point.PointID.to_s == "1328013"
        case point_name[-7..-1]
        when "电流有效值A路"
          alarm.update(current: ps.try(:value).try(:to_s), cur_warning: point.UpName.present?)
        when "电流有效值B路"
          alarm.update(current2: ps.try(:value).try(:to_s), cur_warning2: point.UpName.present?)
        when "电压有效值A路"
          alarm.update(voltage: ps.try(:value).try(:to_s), volt_warning: point.DnName.present?)
        when "电压有效值B路"
          alarm.update(voltage2: ps.try(:value).try(:to_s), volt_warning2: point.DnName.present?)
        end
      end
    end
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "Room.generate_alarm_data time is #{end_time-start_time}"
    nil
  end
  #  机房菜单字符串数组
  # 返回值: ［"#{menu_id}_#{menu_type}"］
  def menu_to_s
    room_menus = menus.pluck(:menuable_id, :menuable_type)
    room_menus.collect{|x| x.join('_')}
  end

  # 获取一级菜单可显示的二级菜单
  def sub_systems_by_system(system)
    sub_systems.includes(:system, :patterns).select{ |sub| sub.system == system}
  end
end
