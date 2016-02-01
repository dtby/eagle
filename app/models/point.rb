# == Schema Information
#
# Table name: points
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  point_index :string(255)
#  device_id   :integer
#
# Indexes
#
#  index_points_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_d6f3cdbe9a  (device_id => devices.id)
#

class Point < ActiveRecord::Base
  belongs_to :device
  has_one :point_alarm, dependent: :destroy
  has_many :alarm_histories, dependent: :destroy
  has_many :point_histories, dependent: :destroy

  # 取得节点的value
  def value
    $redis.hget "eagle_point_value", point_index.to_s
  end

  #创建PointAlarm对象
  # Point.monitor_db
  def self.monitor_db
    start_time = DateTime.now.strftime("%Q").to_i
    generate_digital_alarm
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "generate_digital_alarm time is #{end_time-start_time}"
   
    datas_to_hash DigitalPoint

    nil
  end

  # Point.generate_digital_alarm
  def self.generate_digital_alarm
    DigitalAlarm.all.each do |da|
      $redis.hset "eagle_digital_alarm", da.PointID, da.Status
    end
    nil
  end

  def self.datas_to_hash class_name
    start_time = DateTime.now.strftime("%Q").to_i
    class_name.all.each do |ap|

      start_time = DateTime.now.strftime("%Q").to_i

      point = Point.find_by(point_index: ap.PointID)
      state = $redis.hget "eagle_digital_alarm", ap.PointID.to_s

      device = point.try(:device)
      room = point.try(:device).try(:room)
      sub_system = device.try(:pattern).try(:sub_system)

      next unless point.present? && device.present? && room.present? && sub_system.present?

      end_time = DateTime.now.strftime("%Q").to_i
      logger.info "eagle_digital_alarm time is #{end_time-start_time}"

      start_time = DateTime.now.strftime("%Q").to_i
      point_alarm = PointAlarm.find_or_create_by(point: point, room: room, device: device, sub_system: sub_system)
      end_time = DateTime.now.strftime("%Q").to_i
      logger.info "find_or_create_by time is #{end_time-start_time}"

      start_time = DateTime.now.strftime("%Q").to_i
      point_alarm.update(state: state, comment: ap.Comment, is_checked: false) if state != point_alarm.state
      end_time = DateTime.now.strftime("%Q").to_i
      logger.info "update time is #{end_time-start_time}"

    end
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "Point.monitor_db time is #{end_time-start_time}"
  end
end
