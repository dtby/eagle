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

class PointAlarm < ActiveRecord::Base
  belongs_to :point

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
end
