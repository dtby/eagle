# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Room < ActiveRecord::Base
  has_many :menus, dependent: :destroy
  has_many :systems, source: 'menuable', source_type: 'System', through: :menus

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
      system_hash.each do |sys_name, sub_systems|
        sub_systems.each do |sub_system|
          system = System.find_or_create_by(sys_name: sys_name, sub_system: sub_system.first)
        end
      end
    end
  end
end
