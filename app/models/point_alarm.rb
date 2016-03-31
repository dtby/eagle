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
#  alarm_type    :integer
#  alarm_value   :string(255)
#  checked_at    :datetime
#  checked_user  :string(255)
#  is_checked    :boolean
#
# Indexes
#
#  index_point_alarms_on_device_id      (device_id)
#  index_point_alarms_on_point_id       (point_id)
#  index_point_alarms_on_room_id        (room_id)
#  index_point_alarms_on_sub_system_id  (sub_system_id)
#
# Foreign Keys
#
#  fk_rails_72669ae946  (room_id => rooms.id)
#  fk_rails_776a91d70e  (device_id => devices.id)
#  fk_rails_d8bc97a1a7  (sub_system_id => sub_systems.id)
#  fk_rails_de15df710f  (point_id => points.id)
#

class PointAlarm < ActiveRecord::Base
  belongs_to :point
  belongs_to :room
  belongs_to :device
  belongs_to :sub_system

  after_update :update_alarm_history, if: "checked_at_changed?"
  # after_update :update_is_checked, if: :no_alarm?
  after_create :generate_alarm_history
  after_update :send_notification, if: "is_checked_changed?"

  default_scope { where.not(state: nil).order("updated_at DESC") }

  enum alarm_type: [:alarm, :digital]

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

  scope :checked, -> {where("point_alarms.checked_at is not null")}
  scope :unchecked, -> {where("point_alarms.checked_at is null")}
  scope :is_warning_alarm, -> {where.not(state: 0)}
  scope :order_desc, -> {order("updated_at DESC")}
  scope :get_alarm_point_by_room, -> (room_id) { where(room_id: room_id)}

  def meaning
    value_meaning = $redis.hget "eagle_value_meaning", self.try(:point).try(:point_index)
    return "" if value_meaning.nil?
    index = self.state
    if self.alarm_type == "alarm"
      index = self.state<0 ? (self.state+2) : (self.state+1)
    end
    value_meaning.split("-")[index]
  end

  def self.keyword start_time, end_time
    return self.all if start_time.blank? && end_time.blank?
    self.where("created_at > ? AND created_at < ?", start_time.to_datetime, end_time.to_datetime)
  end

  def check_alarm_by_user user_name
    AlarmProcessJob.set(queue: :alarm).perform_later(self.try(:point).try(:point_index), user_name)
    self.update(checked_user: user_name)
  end

  private

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

    def send_notification
      # id, device_name, pid, state, created_at, updated_at, 
      # is_checked, point_id, comment, type, meaning, alarm_value
      return if self.is_checked?
      NotificationSendJob.set(queue: :message).perform_later(self.id)
    end
end
