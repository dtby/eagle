# == Schema Information
#
# Table name: points
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  point_index     :string(255)
#  device_id       :integer
#  state           :boolean          default(TRUE)
#  point_type      :integer
#  max_value       :string(255)
#  min_value       :string(255)
#  s_report        :integer          default(0)
#  comment         :string(255)
#  u_up_value      :float(24)        default(0.0)
#  d_down_value    :float(24)        default(0.0)
#  main_alarm_show :integer          default(0)
#  tag             :integer
#
# Indexes
#
#  index_points_on_device_id    (device_id)
#  index_points_on_point_index  (point_index)
#

class Point < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :number_type, :status_type, :alarm_type
  # validates_uniqueness_of :point_index

  belongs_to :device
  has_one :point_alarm, dependent: :destroy
  has_many :alarm_histories, dependent: :destroy
  has_many :point_histories, dependent: :destroy

  default_scope { where(state: true).order("cast(points.name as unsigned) asc") }

  enum point_type: [:analog, :digital]
  enum main_alarm_show: ['不显示', '显示']
  enum s_report: ['关闭', '打开']
  enum tag: [:number_type, :alarm_type, :status_type]

  scope :analog, -> {where(point_type: 0)}
  scope :digital, -> {where(point_type: 1)}
  scope :main_alarm_show, -> (room) { where(main_alarm_show: true, device: room.devices) }
  @@DATA_RESOURCE = {:analog => AnalogPoint, 
                     :digital => DigitalPoint}

  def self.clear_invalid_points
    count = 0
    Point.all.each do |point|
      if point.device.blank?
        count++
        point.delete
      end
    end
    p "clear #{count} invalid point"
    nil
  end

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

    color = "green"
    if (value.present? && max_value != 0 && min_value != 0)
      if value > max_value
        color = "red"
      elsif value < min_value
        color = "blue"
      elsif value.between?(min_value, max_value)
        color = "green"
      end
    end
    color
  end

  def update_params(params)
    params[:s_report] = params[:s_report].to_i
    params[:main_alarm_show] = params[:main_alarm_show].to_i
    flag = update_attributes(params)
    # p self.inspect
    # p point_index
    
    # resource = @@DATA_RESOURCE[point_type.to_sym].find(point_index.to_i).sql
    # p resource
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

        update_time = DateTime.new(cos.ADate.year, cos.ADate.month, cos.ADate.day, cos.ATime.hour,cos.ATime.min, cos.ATime.sec) - 8.hour
        logger.info "DigitalAlarm size is #{PointAlarm.is_warning_alarm.size}, #{da.PointID}, #{point_alarm.state}  => #{state}, in #{update_time}"
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
        checked_user, checked_at, is_checked = (state == 0)? ["系统确认", DateTime.now, true] : ["", nil, false]
        update_time = DateTime.new(cos.ADate.year, cos.ADate.month, cos.ADate.day, cos.ATime.hour,cos.ATime.min, cos.ATime.sec) - 8.hour
        logger.info "AnalogAlarm size is #{PointAlarm.is_warning_alarm.size}, #{aa.PointID}, #{point_alarm.state}  => #{state}, in #{update_time}"
        point_alarm.update(state: state, comment: dp.try(:Comment),
          is_checked: (state == 0), updated_at: update_time, alarm_type: 0,
          room_id: point.try(:device).try(:room).try(:id), device_id: point.try(:device).try(:id),
          checked_user: checked_user, checked_at: checked_at,
          sub_system_id: point.try(:device).try(:pattern).try(:sub_system).try(:id),
          alarm_value: cos.AlarmValue)
      end
    end
    logger.info "DigitalAlarm size is #{PointAlarm.is_warning_alarm.size}"
    nil
  end
  # Point.datas_to_hash
  def self.datas_to_hash
    start_time_all = DateTime.now.strftime("%Q").to_i

    # 查询是否有新的告警出现
    generate_point_alarm

    # 查询告警是否已经解除
    PointAlarm.is_warning_alarm.each do |pa|
      update_time = pa.updated_at
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
      if pa.state != state
        checked_user, checked_at, is_checked = (state == 0)? ["系统确认", DateTime.now, true] : ["", nil, false]
        pa.update(state: state, updated_at: update_time, alarm_value: alarm_value, checked_user: checked_user, checked_at: checked_at, is_checked: is_checked)
        logger.info "update_time is #{update_time}"
      end
    end
    end_time_all = DateTime.now.strftime("%Q").to_i
    logger.info "Point.monitor_db time is #{end_time_all-start_time_all}"

  end

  def update_report_show device, params
    return if device.blank?
    sql = ActiveRecord::Base.connection()
    sql.update "update points set s_report = 0 where device_id = #{device}"
    return if params.blank?
    points = params.try(:keys).try(:join, ',')
    sql.update "update points set s_report = 1 where id in (#{points})"
  end
end
