# == Schema Information
#
# Table name: point_alarms
#
#  id         :integer          not null, primary key
#  pid        :integer
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  point_id   :integer
#  is_checked :boolean          default(FALSE)
#
# Indexes
#
#  index_point_alarms_on_point_id  (point_id)
#
# Foreign Keys
#
#  fk_rails_de15df710f  (point_id => points.id)
#

class PointAlarm < ActiveRecord::Base
  belongs_to :point
  after_update :update_alarm_history, if: "self.is_checked_changed?"
  after_create :generate_alarm_history

  # PointAlarm.get_alarm_point_by_room 1
  def self.get_alarm_point_by_room room_id
    devices = Device.by_room room_id
    return {} unless devices.present?
    points = []
    devices.collect { |device| points.concat device.points.pluck(:point_index)}

    point_alarms = {}
    Point.where(point_index: points).each do |point|
      state = point.try(:point_alarm).try(:state)
      point_alarms[point.point_index] = state if state.present? && state != 0
    end
    point_alarms
  end

  private

    def update_alarm_history
      alarm_history = self.try(:point).try(:alarm_histories).try(:last)
      alarm_history.check_state = self.state
      alarm_history.checked_time = DateTime.now if self.is_checked
      alarm_history.save
    end

    def generate_alarm_history
      AlarmHistory.find_or_create_by(point: self.point, check_state: self.state)
    end
end
