# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  link       :string(255)
#

class Room < ActiveRecord::Base

  validates_presence_of :name, :link
  validates_uniqueness_of :name, :link
  has_many :menus, dependent: :destroy
  has_many :systems, source: 'menuable', source_type: 'System', through: :menus
  has_many :sub_systems, source: 'menuable', source_type: 'SubSystem', through: :menus
  has_many :user_rooms
  has_many :users, through: :user_rooms

  # Room.get_computer_room_list
  def self.get_computer_room_list
    # 名字-> [{系统 -> 设备}, ... {系统 -> 设备}]
    point_hash = {}
    datas_to_hash AnalogPoint, point_hash
    datas_to_hash DigitalPoint, point_hash
    generate_system point_hash
  end

  def self.generate_system  point_hash
    # 机房 => { 系统 => 子系统 => {点 => 数据}
    point_hash.each do |room, system_hash|
      room = Room.find_or_create_by(name: room)
      system_hash.each do |sub_name, patterns|
        sub_system = SubSystem.find_or_create_by(name: sub_name)
        patterns.each do | name, points|
          pattern = select_pattern_by_name name
          device = Device.find_or_create_by(name: name, pattern: pattern)
          points.each do |name, value|
            p = Point.find_or_create_by(name: name, device: device, point_index: value)
          end
        end
      end
    end
  end

  def self.select_pattern_by_name name
    Pattern.all.each do |p|
      return p if name.include? p.name
    end
    nil
  end

  def self.datas_to_hash class_name, group_hash
    class_name.all.each do |ap|
      # BayName: 机房A-配电系统
      # 机房A -> 配电系统 -> 配电柜 -> 
      bay_info = ap.BayName.split("-")
      group_hash[bay_info.first] = {} unless group_hash[bay_info.first].present?
      group_hash[bay_info.first][ap.GroupName] = {} unless group_hash[bay_info.first][ap.GroupName].present?

      point_hash = {}
      group_hash[bay_info.first][ap.GroupName][bay_info.second] = {} unless group_hash[bay_info.first][ap.GroupName][bay_info.second].present?
      group_hash[bay_info.first][ap.GroupName][bay_info.second][ap.PointName] = ap.PointID
    end
    group_hash
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
