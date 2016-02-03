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
    # start_time = DateTime.now.strftime("%Q").to_i
    # generate_digital_alarm
    # end_time = DateTime.now.strftime("%Q").to_i
    # logger.info "generate_digital_alarm time is #{end_time-start_time}"
   
    datas_to_hash

    nil
  end

  # Point.generate_digital_alarm
  def self.generate_digital_alarm
    DigitalAlarm.all.each do |da|
      $redis.hset "eagle_digital_alarm", da.PointID, da.Status
    end
    nil
  end

  def self.generate_point_alarm reset = false

    if PointAlarm.all.size > 0 && (!reset)
      updated_at = PointAlarm.order("updated_at DESC").first.try(:updated_at)
      das = DigitalAlarm.where("ADate >= ? AND ATime > ?", updated_at.strftime("%Y-%m-%d"), updated_at.strftime("%H:%M:%S"))   
      aas = AnalogAlarm.where("ADate >= ? AND ATime > ?", updated_at.strftime("%Y-%m-%d"), updated_at.strftime("%H:%M:%S"))   
    else
      das = DigitalAlarm.all
      aas = AnalogAlarm.all
    end

    das.each do |da|
      point = Point.find_by(point_index: da.PointID)
      next unless point.present?
      puts "da is #{da.inspect}"
      cos = DigitalAlarm.order("ADate DESC, ATime DESC").find_by(PointID: da.PointID)
      dp = DigitalPoint.find_by(PointID: da.PointID)
      state = cos.try(:Status)

      point_alarm = PointAlarm.find_or_create_by(point_id: point.id)
      update_time = DateTime.new(da.ADate.year, da.ADate.month, da.ADate.day, da.ATime.hour,da.ATime.min, da.ATime.sec)
      if state != point_alarm.state
        point_alarm.update(state: state, comment: dp.Comment, 
          is_checked: false, updated_at: update_time, alarm_type: 1, 
          room_id: point.try(:device).try(:room).try(:id), 
          device_id: point.try(:device).try(:id), 
          sub_system_id: point.try(:device).try(:sub_system).try(:id))
      end
    end

    aas.each do |aa|
      point = Point.find_by(point_index: aa.PointID)
      next unless point.present?
      puts "aa is #{aa.inspect}"
      cos = AnalogAlarm.order("ADate DESC, ATime DESC").find_by(PointID: aa.PointID)
      dp = AnalogPoint.find_by(PointID: aa.PointID)
      state = cos.try(:Status)

      point_alarm = PointAlarm.find_or_create_by(point_id: point.id)
      update_time = DateTime.new(aa.ADate.year, aa.ADate.month, aa.ADate.day, aa.ATime.hour,aa.ATime.min, aa.ATime.sec)
      if state != point_alarm.state
        point_alarm.update(state: state, comment: dp.Comment, 
          is_checked: false, updated_at: update_time, alarm_type: 0,
          room_id: point.try(:device).try(:room).try(:id), 
          device_id: point.try(:device).try(:id), 
          sub_system_id: point.try(:device).try(:sub_system).try(:id))
      end
    end
  end
  # Point.datas_to_hash
  def self.datas_to_hash
    start_time_all = DateTime.now.strftime("%Q").to_i

    # 查询是否有新的告警出现
    generate_point_alarm

    # 查询告警是否已经解除
    PointAlarm.is_warning_alarm.each do |pa|
      update_time = pa.updated_at
      if pa.alarm_type == 1
        cos = DigitalAlarm.order("ADate DESC, ATime DESC").find_by(PointID: pa.try(:point).try(:point_index))
      else
        cos = AnalogAlarm.order("ADate DESC, ATime DESC").find_by(PointID: pa.try(:point).try(:point_index))
      end
      pa.update(state: cos.try(:Status), updated_at: update_time) if pa.state != cos.try(:Status)
    end

    end_time_all = DateTime.now.strftime("%Q").to_i
    logger.info "Point.monitor_db time is #{end_time_all-start_time_all}"

  end
end
