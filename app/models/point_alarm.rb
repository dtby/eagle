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
#  is_checked    :boolean          default(FALSE)
#  comment       :string(255)
#  room_id       :integer
#  device_id     :integer
#  sub_system_id :integer
#  alarm_type    :integer
#  alarm_value   :string(255)
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

  self.per_page = 10

  after_update :update_alarm_history, if: "self.is_checked_changed?"
  # after_update :update_is_checked, if: :no_alarm?
  after_create :generate_alarm_history

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

  scope :checked, -> {where("point_alarms.is_checked = true OR point_alarms.state= 0")}
  scope :unchecked, -> {where(is_checked: false)}
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

  private

    def update_alarm_history
      alarm_history = self.try(:point).try(:alarm_histories).try(:last)
      alarm_history.check_state = self.state
      alarm_history.checked_time = DateTime.now if self.is_checked
      alarm_history.save
    end

    def update_is_checked
      self.update(is_checked: true)
    end

    def no_alarm?
      self.state == 0
    end

    def generate_alarm_history
      AlarmHistory.find_or_create_by(point: self.point, check_state: self.state)
    end
end
