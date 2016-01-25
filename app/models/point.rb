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
    datas_to_hash DigitalPoint
    nil
  end

  def self.datas_to_hash class_name
    class_name.all.each do |ap|
      point = Point.find_by(point_index: ap.PointID)
      cos = DigitalAlarm.find_by(PointID: ap.PointID)
      next unless point.present?
      point_alarm = PointAlarm.find_or_create_by(point: point, room: point.try(:device).try(:room))
      point_alarm.update(state: cos.try(:Status), comment: ap.Comment, is_checked: false) if cos.try(:Status) != point_alarm.state
    end
  end
end
