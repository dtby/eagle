# == Schema Information
#
# Table name: point_alarms
#
#  id            :integer          not null, primary key
#  pid           :integer
#  state         :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  point_id      :integer
#  comment       :string(255)
#  room_id       :integer
#  device_id     :integer
#  sub_system_id :integer
#  alarm_value   :string(255)
#  checked_at    :datetime
#  checked_user  :string(255)
#  is_checked    :boolean
#  alarm_type    :string(255)
#  reported_at   :datetime
#  cleared_at    :datetime
#  meaning       :string(255)
#  is_cleared    :boolean
#  device_name   :string(255)
#
# Indexes
#
#  index_point_alarms_on_device_id      (device_id)
#  index_point_alarms_on_point_id       (point_id)
#  index_point_alarms_on_room_id        (room_id)
#  index_point_alarms_on_sub_system_id  (sub_system_id)
#

class PointAlarm < ActiveRecord::Base

  establish_connection "#{Rails.env}".to_sym

  belongs_to :point
  belongs_to :room
  belongs_to :device
  belongs_to :sub_system

  after_create :generate_alarm_history
  
  after_update :send_notification, if: "is_cleared_changed?"
  after_update :update_alarm_history, if: "checked_at_changed?"

  default_scope { order("reported_at DESC") }

  #参数point_index
  #返回单个point的id
  def self.get_point_id point_index
    Point.find_by(point_index: point_index).id
  end

  #参数point_index
  #返回单个point_alarm对象
  def self.get_point_alarm point_index
    point = Point.find_by(point_index: point_index)
    PointAlarm.find_by(point_id: point.id)
  end

  scope :checked, -> { where(is_checked: true) }
  scope :unchecked, -> { where(is_checked: false) }
  scope :cleard, -> { where(is_cleared: true) }
  scope :active, -> { where(is_cleared: false) }
  scope :uncheck_or_one_day_checked, -> { where( 'is_checked = ? OR checked_at > ?', false, 1.day.ago ) }

  scope :order_desc, -> {order("reported_at DESC")}
  scope :get_alarm_point_by_room, -> (room_id) { where(room_id: room_id)}

  # point_index：设备点号
  # device_name：点名
  # alarm_flag: 0代表报警， 1代表解除
  # meaning： 告警状态
  # alarm_type: 告警类型
  # time： 告警时间
  def update_info params
    _is_cleared = params[:alarm_flag].to_i == 1 ? true : false
    self.is_cleared = _is_cleared
    self.device_name = params[:device_name]
    self.is_cleared = _is_cleared
    _time = Time.zone.parse params[:time]
    if _is_cleared
      self.cleared_at = _time
      self.checked_at = _time
      self.checked_user = "系统确认"
      self.is_checked = true
    else
      self.reported_at = _time
      self.cleared_at = nil
      self.checked_at = nil
      self.checked_user = ""
      self.is_checked = false
    end
    self.meaning = params[:meaning]
    self.alarm_type = params[:alarm_type]

    point = Point.find_by(id: params["point_id"])
    self.room_id = point.try(:device).try(:room).try(:id)
    self.device_id = point.try(:device).try(:id)
    self.sub_system_id = point.try(:device).try(:pattern).try(:sub_system).try(:id)
    self.save
  end

  def self.keyword start_time, end_time
    return self.all if start_time.blank? && end_time.blank?
    self.where("created_at > ? AND created_at < ?", start_time.to_datetime, end_time.to_datetime)
  end

  def check_alarm_by_user user_name
    AlarmProcessJob.set(queue: :alarm).perform_later(self.try(:point).try(:point_index), user_name)
    self.update(checked_user: user_name)
  end

  def notification_to_app os
    tag_list = [self.try(:room).try(:name)]
    return unless tag_list.present?

    custom_content = {
      custom_content: get_notify_content_hash
    }
    params = {}
    if self.state.zero?
      title = "告警消除！"
      content = "【告警消除】#{self.try(:room).try(:name)}-#{self.try(:device).try(:name)}的#{self.try(:point).try(:name)}告警消除！"
    else
      title = "新告警！"
      content = "【新告警】#{self.try(:room).try(:name)}-#{self.try(:device).try(:name)}的#{self.try(:point).try(:name)}出现告警！"
    end

    sender = Xinge::Notification.instance.send os
    begin
      response = sender.pushTagsDevice(title, content, tag_list, "OR", params, custom_content)
    rescue Exception => e
      puts "Exception is #{e.inspect}"
    ensure
      puts "response is #{response.inspect}"
    end
  end

  def notification_to_ios
    notification_to_app :ios
  end

  def notification_to_android
    notification_to_app :android
  end

  def notification_to_wechat
    body = {
      alarm: get_notify_content_hash
    }
    conn = Faraday.new(:url => "http://115.29.211.21/") do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end
    response = conn.post '/alarms/fetch', body, Accept: "application/json"
  end

  def as_json option=nil
    get_notify_content_hash
  end

  private

    def send_notification
      # id, device_name, pid, state, created_at, updated_at,
      # is_checked, point_id, comment, type, meaning, alarm_value
      return unless self.state
      logger.info "---- start NotificationSendJob #{self.id}, #{self.try(:point).try(:name)} ----"
      NotificationSendJob.set(queue: :message).perform_later(self.id)
      logger.info "---- end NotificationSendJob #{self.id}, #{self.try(:point).try(:name)} ----"
    end

    def get_notify_content_hash
      {
        id: self.id,
        device_name: self.try(:device).try(:name),
        pid: self.pid,
        room_id: self.room_id,
        reported_at: self.reported_at.try(:strftime, "%Y-%m-%d %H:%M:%S"),
        cleared_at: self.cleared_at.try(:strftime, "%Y-%m-%d %H:%M:%S"),
        checked_at: self.checked_at.try(:strftime, "%Y-%m-%d %H:%M:%S"),
        is_checked: self.is_checked,
        is_cleared: self.is_cleared,
        point_id: self.point_id,
        point_name: self.device_name,
        type: self.alarm_type,
        meaning: self.meaning
      }
    end

    def update_alarm_history
      alarm_history = self.try(:point).try(:alarm_histories).try(:last)
      return unless alarm_history.present?
      alarm_history.check_state = self.state
      alarm_history.checked_user = self.checked_user
      alarm_history.checked_time = DateTime.now if self.checked_at.present?
      alarm_history.save
    end

    def update_is_checked
      self.update(checked_at: DateTime.now)
    end

    def no_alarm?
      self.state == 0
    end

    def generate_alarm_history
      AlarmHistory.find_or_create_by(point: self.point, check_state: self.state)
    end
end
