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
#  state       :boolean          default(TRUE)
#  point_type  :integer
#  max_value   :string(255)
#  min_value   :string(255)
#
# Indexes
#
#  index_points_on_device_id    (device_id)
#  index_points_on_point_index  (point_index)
#
# Foreign Keys
#
#  fk_rails_d6f3cdbe9a  (device_id => devices.id)
#

class Point < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :number_type, :status_type, :alarm_type

  belongs_to :device
  has_one :point_alarm, dependent: :destroy
  has_many :alarm_histories, dependent: :destroy
  has_many :point_histories, dependent: :destroy

  default_scope { where(state: true).order("cast(name as unsigned) asc") }

  enum point_type: [:analog, :digital]

  scope :analog, -> {where(point_type: 0)}
  scope :digital, -> {where(point_type: 1)}

  # 取得节点的value
  def value
    $redis.hget "eagle_point_value", point_index.to_s
  end

  def history_values count
    count ||= 5
    caches = ($redis.hget "eagle_schedule_point_history", point_index) || (["0"]*24).join("-")
    values = caches.split("-")
    hash = {}
    hour = Time.now.beginning_of_hour
    values[-count..-1].reverse.each_with_index do |value, index|
      hash[hour-index.hour] = value
    end
    hash
  end

  def meaning
    value_meaning = $redis.hget "eagle_value_meaning", self.try(:point_index)
    return value if (value_meaning.nil? || point_type == "analog")
    value_meaning.split("-")[(value.try(:to_i)||0)]
  end

  def color
    value = self.try(:value).try(:to_f)
    max_value = self.try(:max_value).try(:to_f)
    min_value = self.try(:min_value).try(:to_f)

    color = "black"
    if (value.present? && max_value.present? && min_value.present?)
      if value > max_value
        color = "red"
      elsif value < min_value
        color = "blue"
      elsif value.between?(min_value, max_value)
        color = "black"
      end
    end
    color
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

  # Point.generate_point_alarm true
  def self.generate_point_alarm reset = false

    if PointAlarm.all.size > 0 && (!reset)
      updated_at = PointAlarm.order("updated_at DESC").first.try(:updated_at)
      puts "----- updated_at is #{updated_at} -----"
      logger.info "----- updated_at is #{updated_at} -----"
      das = DigitalAlarm.where("ADate >= ?", updated_at.strftime("%Y-%m-%d"))   
      aas = AnalogAlarm.where("ADate >= ?", updated_at.strftime("%Y-%m-%d"))   
    else
      das = DigitalAlarm.all
      aas = AnalogAlarm.all
    end

    das.each do |da|
      point = Point.find_by(point_index: da.PointID.to_s)
      next unless point.present?
      
      cos = DigitalAlarm.order("ADate DESC, ATime DESC, AMSecond DESC").find_by(PointID: da.PointID)
      dp = DigitalPoint.find_by(PointID: da.PointID)
      state = cos.try(:Status).try(:to_i)

      point_alarm = PointAlarm.unscoped.find_or_create_by(point_id: point.id)
      
      if state != point_alarm.state
        checked_user, checked_at, is_checked = (state == 0)? ["系统确认", DateTime.now, true] : ["", nil, false]
        
        update_time = DateTime.new(cos.ADate.year, cos.ADate.month, cos.ADate.day, cos.ATime.hour,cos.ATime.min, cos.ATime.sec)
        puts "DigitalAlarm size is #{PointAlarm.is_warning_alarm.size}, #{da.PointID}, #{point_alarm.state}  => #{state}, in #{update_time}"
        point_alarm.update(state: state, comment: dp.try(:Comment), 
          is_checked: is_checked, updated_at: update_time, alarm_type: 1, 
          room_id: point.try(:device).try(:room).try(:id), device_id: point.try(:device).try(:id), 
          checked_user: checked_user, checked_at: checked_at, 
          sub_system_id: point.try(:device).try(:pattern).try(:sub_system).try(:id))
      end
    end

    aas.each do |aa|
      point = Point.find_by(point_index: aa.PointID.to_s)
      next unless point.present?
      cos = AnalogAlarm.order("ADate DESC, ATime DESC, AMSecond DESC").find_by(PointID: aa.PointID)
      dp = AnalogPoint.find_by(PointID: aa.PointID)
      
      state = cos.try(:Status)
      if ((state == 1 && state.class == Integer) || (state && state.class == TrueClass))
        state = 0
      else
        case cos.try(:AlarmType).try(:to_i) || 2
        when 1
          state = -2
        when 2
          state = -1
        when 3
          state = 1
        when 4
          state = 2
        end
      end


      point_alarm = PointAlarm.unscoped.find_or_create_by(point_id: point.id)
      
      if state != point_alarm.state
        puts "AnalogAlarm size is #{PointAlarm.is_warning_alarm.size}, #{aa.PointID}, #{point_alarm.state}  => #{state}, in #{update_time}"
        checked_user, checked_at, is_checked = (state == 0)? ["系统确认", DateTime.now, true] : ["", nil, false]
        update_time = DateTime.new(cos.ADate.year, cos.ADate.month, cos.ADate.day, cos.ATime.hour,cos.ATime.min, cos.ATime.sec)
        point_alarm.update(state: state, comment: dp.try(:Comment), 
          is_checked: (state == 0), updated_at: update_time, alarm_type: 0,
          room_id: point.try(:device).try(:room).try(:id), device_id: point.try(:device).try(:id),
          checked_user: checked_user, checked_at: checked_at,  
          sub_system_id: point.try(:device).try(:pattern).try(:sub_system).try(:id), 
          alarm_value: cos.AlarmValue)
      end
    end
    puts "DigitalAlarm size is #{PointAlarm.is_warning_alarm.size}"
    nil
  end
  # Point.datas_to_hash
  def self.datas_to_hash
    start_time_all = DateTime.now.strftime("%Q").to_i

    # 查询是否有新的告警出现
    generate_point_alarm

    # 查询告警是否已经解除
    PointAlarm.is_warning_alarm.each do |pa|
      alarm_value = ""
      if pa.alarm_type == "digital"
        cos = DigitalAlarm.order("ADate DESC, ATime DESC, AMSecond DESC").find_by(PointID: pa.try(:point).try(:point_index).try(:to_i))
        state = cos.try(:Status).try(:to_i)
      else
        cos = AnalogAlarm.order("ADate DESC, ATime DESC, AMSecond DESC").find_by(PointID: pa.try(:point).try(:point_index).try(:to_i))
        state = cos.try(:Status)
        if ((state == 1 && state.class == Integer) || (state && state.class == TrueClass))
          state = 0
        else
          case cos.try(:AlarmType).try(:to_i) || 2
          when 1
            state = -2
          when 2
            state = -1
          when 3
            state = 1
          when 4
            state = 2
          end
        end
        alarm_value = cos.try(:AlarmValue) || ""
      end
      # update_time = DateTime.new(cos.ADate.year, cos.ADate.month, cos.ADate.day, cos.ATime.hour, cos.ATime.minute, cos.ATime.second)
      if pa.state != state
        checked_user, checked_at, is_checked = (state == 0)? ["系统确认", DateTime.now, true] : ["", nil, false]
        pa.update(state: state, alarm_value: alarm_value, checked_user: checked_user, checked_at: checked_at, is_checked: is_checked)  
      end
    end
    end_time_all = DateTime.now.strftime("%Q").to_i
    logger.info "Point.monitor_db time is #{end_time_all-start_time_all}"

  end
end
