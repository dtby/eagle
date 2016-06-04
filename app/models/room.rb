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
#  area_id      :integer
#
# Indexes
#
#  index_rooms_on_area_id  (area_id)
#

class Room < ActiveRecord::Base
  include RoomsHelper
  validates_presence_of :name#, :link
  validates_uniqueness_of :name

  belongs_to :area
  has_many :menus, dependent: :destroy
  has_many :systems, source: 'menuable', source_type: 'System', through: :menus
  has_many :sub_systems, source: 'menuable', source_type: 'SubSystem', through: :menus
  has_many :user_rooms, dependent: :destroy
  has_many :attachments, dependent: :destroy
  has_many :users, through: :user_rooms

  has_many :devices, dependent: :destroy
  has_many :point_alarms, dependent: :destroy

  after_commit :notify_task, :on => [:create, :update]

  def as_json(options=nil)
    {
      id: id,
      name: name,
      link: link,
      monitor_link: monitor_link,
      pic: self.pic
    }
  end

  def pic
    path = Attachment.find_by("tag like ? AND room_id = ?", "%主图%", id).try(:image_url, :w_640)
    "#{ActionController::Base.asset_host}#{path}" if path.present?
  end

  def fetch_rooms_info
    rooms = AnalogPoint.all.distinct(:RSName).pluck(:RSName)
    rooms.each do |room_name|
      room = Room.find_or_create_by name: room_name
    end
  end

  # # Room.get_computer_room_list
  # def self.get_computer_room_list
  #   start_time = DateTime.now.strftime("%Q").to_i
  #   # 名字-> [{系统 -> 设备}, ... {系统 -> 设备}]
  #   point_hash = {}
  #   informations = datas_to_hash AnalogPoint, point_hash
  #   generate_system informations, "analog"

  #   point_hash = {}
  #   informations = datas_to_hash DigitalPoint, point_hash
  #   generate_system informations, "digital"

  #   end_time = DateTime.now.strftime("%Q").to_i
  #   logger.info "Room.get_computer_room_list time is #{end_time-start_time}"
  # end

  # Room.generate_point_value
  # 用于生成点的数值
  def self.generate_point_value
    start_time = DateTime.now.strftime("%Q").to_i
    PointState.all.each do |point_state|
      $redis.hset "eagle_point_value", point_state.try(:PointID), (point_state.try(:Status))
    end
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "Room.generate_point_value time is #{end_time-start_time}"
  end

  # Room.generate_value_meaning
  # 用户生成点的值， 对应的意义， 若该值无具体含义，则显示点的值
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

  def process
    table_names = [AnalogPoint, DigitalPoint]
    now_update_time = DateTime.now
    rooms_name = analyzed_room

    table_names.each do |table_name|
      rooms_name.each do |room_name|
        thread = Thread.start do 
          analyzed_table table_name, room_name, now_update_time
        end
        thread.join
      end
    end
  end

  def analyzed_room
    AnalogPoint.all.distinct(:RSName).pluck(:RSName)
  end

  def analyzed_table table_name, now_update_time
    data = table_name.where("RSName = ? and Comment <> ''", name)
    if table_name == AnalogPoint
      list = data.pluck(:BayName, :GroupName, :PointName, :PointID, :RSName, :Comment, :UpValue, :DnValue)
    else
      list = data.pluck(:BayName, :GroupName, :PointName, :PointID, :RSName, :Comment)
    end

    room_devices = []

    return if list.blank?
    list.each do |items|
      device_name                   = items[0].split('-')[-1]
      sub_system_name, pattern_name = items[1].split('-')
      point_name                    = items[2]
      point_index                   = items[3]
      comment                       = items[5]
      max_value                     = items[6].to_f
      min_value                     = items[7].to_f
      
      if sub_system_name.present?
        sub_system = SubSystem.find_by(name: sub_system_name)
      end
      menu = Menu.find_or_create_by(room: self, menuable_id: sub_system.try(:id), menuable_type: "SubSystem")
      menu.update(updated_at: DateTime.now)
      
      if device_name.include?('温湿度') 
        if name.eql?('云南广福城')
          device_name = '温湿度'
        else
          device_name = device_name.remove(/(\d+)$/)
        end
      end
      device = self.devices.find_or_create_by(name: device_name)
      room_devices << device

      pattern_name = device.name.remove(/\d+(主|备)?/)
      pattern = Pattern.find_or_create_by(name: pattern_name, sub_system: sub_system)
      device.pattern = pattern
      device.updated_at = now_update_time
      device.save
            
      point = device.points.find_or_create_by(name: point_name, point_index: point_index)
      point.point_type = table_name.name.downcase.remove('point')
      point.comment    = comment.upcase
      point.max_value  = max_value
      point.min_value  = min_value
      point.state      = true
      point.updated_at = now_update_time
      point.save
    end
    Point.where(device: room_devices).where('updated_at < ?', now_update_time).update_all(state: false)
    Device.where('room_id = ? and updated_at < ?', id, now_update_time).update_all(state: false)
  end

  # 用struct来优化
  # def self.datas_to_hash class_name, group_hash
  #   informations = []
  #   class_name.where("RSName <> ?", "云南广福城").each do |ap|
  #     next if ap.BayName.blank? || ap.GroupName.blank? || ap.PointName.blank?
  #     information = Information.new
  #     # BayName: 机房-设备
  #     # GroupName: 系统-风格
  #     # PointName: （子机房-）点名

  #     sub_system, pattern = ap.GroupName.split("-")
  #     sub_system.delete! "普通" if sub_system.include? "普通"
  #     pattern = "普通温湿度" if pattern == "th802"

  #     bay_info = ap.BayName.upcase.split("-")
  #     device_name = bay_info.second
  #     point_name = ap.PointName.upcase
  #     sub_room, point_name = ap.PointName.split("-") if ap.PointName.include?("-") && ["温湿度系统", "漏水系统", "消防系统"].include?(sub_system)

  #     next if point_name.blank? || device_name.blank?
  #     if bay_info.second.present? && (/\d+机柜/ =~ bay_info.second)
  #       index = bay_info.second.index "机柜"
  #       line = bay_info.second[index+2..-1]

  #       point_name.prepend bay_info.second[0..index-1]
  #       point_name += line

  #       device_name = bay_info.second[0] + "机柜"  # C机柜
  #     end
  #     device_name = "温湿度" if device_name.include? "温湿度"

  #     information.room        = bay_info.first
  #     information.sub_room    = sub_room if ["温湿度系统", "漏水系统", "消防系统"].include? sub_system
  #     information.sub_system  = sub_system
  #     information.pattern     = pattern
  #     information.device      = sub_room.blank? ? "#{device_name}" : "#{sub_room}#{device_name}"
  #     information.point       = point_name
  #     information.point_index = ap.PointID
  #     information.up_value    = ap.try(:UpValue)
  #     information.down_value  = ap.try(:DnValue)

  #     informations << information
  #   end
  #   informations
  # end

  # def self.generate_system informations, type
  #   # 机房 => { 系统 => 子系统 => { 点 => 数据 }
  #   # 机房 (=> 子机房) => 设备
  #   filter_room = Room.find_by_name '云南广福城'
  #   update_time = DateTime.now
  #   informations.each do |information|
  #     room = Room.find_or_create_by(name: information.room)
  #     sub_system = SubSystem.find_or_create_by(name: information.sub_system)

  #     next if information.pattern.blank?

  #     menu = Menu.find_or_create_by(room: room, menuable_id: sub_system.try(:id), menuable_type: "SubSystem")
  #     menu.update(updated_at: update_time)

  #     pattern = Pattern.find_or_create_by(sub_system_id: sub_system.id, name: information.pattern.try(:strip))
  #     device = Device.unscoped.find_or_create_by(name: information.device, pattern: pattern, room: room)

  #     point = Point.unscoped.find_or_create_by(name: information.point, device: device, point_index: information.point_index)

  #     if information.sub_room.present?
  #       sub_room = SubRoom.find_or_create_by(name: information.sub_room, room: room)
  #       device.sub_room = sub_room
  #     end
  #     device.state      = true
  #     device.updated_at = update_time
  #     device.save

  #     if information.up_value && information.down_value
  #       point.max_value = information.up_value
  #       point.min_value = information.down_value
  #     end
  #     point.point_type  = type
  #     point.state       = true
  #     point.updated_at  = update_time
  #     point.save

  #     check_point information.sub_system, information.point, point.id, device.id
  #   end

  #   points = Point.where(updated_at: DateTime.new(2010,1,1)..15.minute.ago)
  #   points.each do |point|
  #     point.update(state: false)
  #     point.point_alarm.update(state: nil) if point.point_alarm.present?
  #   end
  #   Device.where("room_id <> ?", filter_room.id).where(updated_at: DateTime.new(2010,1,1)..15.minute.ago).update_all(state: false)
  #   Menu.where(menuable_type: "SubSystem", updated_at: DateTime.new(2010,1,1)..15.minute.ago).destroy_all
  #   nil
  # end


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

      device = Device.unscoped.find_or_create_by(name: device_name)
      # alarm = Alarm.find_or_create_by(device_name: (name.split("-").last.remove line), device_id: device.try(:id))
      alarm = Alarm.find_or_create_by(device_name: (name.split("-").last.try(:remove, line)), device_id: device.try(:id))
      points.each_with_index do |point, index|
        ps = PointState.where(PointID: point.PointID).first
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

  def self.get_pue room_id
    pue_cache = ($redis.lrange "pue_#{room_id}", 0, 5).map { |e| MultiJson.load e } rescue []
    if pue_cache.blank?
      now_time = Time.now
      (1..5).each do |offset|
        pue_cache << {
          datetime: (now_time - offset.hour).strftime("%Y-%m-%d %H"),
          value: 0
        }
      end
    end
    pue_cache
  end

  def pue
    device = devices.find_by_name 'PUE'
    [nil, nil] if device.blank?
    points = device.points
    
    chart_points_id = points.where(name: ['IT电费', 'IT碳排放', '空调电费', '空调碳排放']).pluck(:id)
    chart_data = PointHistory.new.query chart_points_id
    single_value_points = {}
    single_points = points.where(name: ['总电费','总排放','总能耗','PUE值','IT设备使用量','空调使用量'])
    single_points.each do |e|
      single_value_points[e.name] = e.value
    end
    [single_value_points, chart_data]
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

  def alarm_count room_id
    point_alarms = PointAlarm.where("room_id = #{room_id} AND (state <> 0 OR checked_at BETWEEN '#{1.day.ago.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{DateTime.now.strftime("%y-%m-%d %H:%M:%S")}')")

    sub_system_ids = point_alarms.pluck(:sub_system_id).compact

    return [] unless sub_system_ids.present?
    counter = Hash.new(0)
    sub_system_ids.each {|val| counter[val] += 1}
    results = []
    counter.each do |item|
      results << {
        device_id: item[0],
        device_name: SubSystem.get_name(item[0]),
        alarm_count: item[-1]
      }
    end
    results
  end

  def report_devices
    sql = ActiveRecord::Base.connection()
    result = sql.select_all "SELECT distinct(d.name) as name, d.id FROM points as p, devices as d where d.room_id = #{id} and p.device_id = d.id and p.s_report = 1;"
    result.rows
  end

  # room 更新后发消息到异步任务
  def notify_task
    params = {type: 'room', data: self.to_json}
    NotifyWeixinJob.set(queue: :sync_info).perform_later(params)
  end

  def refresh
    table_names = [AnalogPoint, DigitalPoint]
    now_update_time = DateTime.now
    rooms_name = analyzed_room

    table_names.each do |table_name|
      analyzed_table table_name, now_update_time
    end
  end
end
