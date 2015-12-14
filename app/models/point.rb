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

class Point < ActiveRecord::Base
  belongs_to :device
  has_one :point_alarm, dependent: :destroy

  # 取得节点的value
  def value
    ps = PointState.where(pid: point_index.to_i).first
    ps.try(:value)
  end

  def self.monitor_db
    datas_to_hash DigitalPoint
  end

  def self.datas_to_hash class_name
    class_name.all.each do |ap|
      point = Point.find_by(point_index: ap.PointID)
      next unless point.present?
      point_alarm = PointAlarm.find_or_create_by(point: point)
      point_alarm.update(state: ap.COS) if ap.COS != point_alarm.state
    end
  end
end
