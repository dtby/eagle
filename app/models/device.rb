# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pattern_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  room_id    :integer
#  pic_path   :string(255)
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#  index_devices_on_room_id     (room_id)
#
# Foreign Keys
#
#  fk_rails_2deefbda3a  (pattern_id => patterns.id)
#  fk_rails_3824183ebe  (room_id => rooms.id)
#

class Device < ActiveRecord::Base
  establish_connection "#{Rails.env}".to_sym
  scope :by_room, ->(room_id) { where("room_id = ?", room_id) }

  belongs_to :pattern
  belongs_to :room
  has_many :points, dependent: :destroy
  has_many :point_histories, dependent: :destroy
<<<<<<< HEAD
  has_one :alarm
=======
  has_many :alarms, dependent: :destroy
  has_many :point_alarms, dependent: :destroy
>>>>>>> 94eec04890f1d237e671420f51e629ff70ab3b70

  after_update :send_notification, if: "name_changed?"
  after_create :send_notification

  def self.get_name room_id, device_id
    $redis.hget "device_name_cache", "#{room_id}_#{device_id}"
  end

  def send_notification
    $redis.hset "device_name_cache", "#{self.room_id}_#{self.id}", self.name
  end

  def pic
    path = pic_path || Attachment.find_by("tag like ? AND room_id = ?", "%#{name}%", room_id).try(:image_url, :w_640)
    "#{ActionController::Base.asset_host}#{path}" if path.present?
  end

  # 获取设备对应的点的值
  def points_value
    view_points = {}

    # 循环分组封装呆显示数据
    # 排序需要修改 2016-3-31
    all_points = points.order("name asc")
    all_points.each do |point|
      state = point.try(:value) || 0
      if point.name.include?('-')
        group = point.name.split('-', 2).try(:first).try(:strip)
        if group.present?
          pn = point.name.upcase.split('-', 2).try(:last).try(:strip)
          view_points[group].blank? ? view_points[group] = { pn => state } : view_points[group].merge!({pn => state })
        end
      else
        view_points["其他"].blank? ? view_points["其他"] = {point.name => state } : view_points["其他"].merge!({point.name => state })
      end
    end

    view_points
  end

  # 获取设备告警
  def points_group show_alarm_type = false
    view_points = {}

    # 循环分组封装呆显示数据
    all_points = points.order("name asc")
    all_points.each do |point|
      state = point.try(:point_alarm).try(:state) || 0
      state = state.to_s + "_" + (point.try(:point_alarm).try(:alarm_type) || "digital") if show_alarm_type
      if point.name.include?('-')
        group = point.name.split('-', 2).try(:first).try(:strip)
        if group.present?
          pn = point.name.split('-', 2).try(:last).try(:strip)
          view_points[group].blank? ? view_points[group] = { pn => state } : view_points[group].merge!({pn => state })
        end
      else
        view_points["其他"].blank? ? view_points["其他"] = {point.name => state } : view_points["其他"].merge!({point.name => state })
      end
    end

    view_points
  end

  def alarm_group
    group = {}
    result = {}
    type_result = {}
    point_alarms = points_group true
    point_alarms.values.map { |value| group.merge! value }
    group.each do |type, value|
      value, alarm_type = value.split("_")
      result[type] = (value.to_i != 0)
      type_result[type] = (alarm_type == "alarm" ?  (value.to_i) : nil)
    end
    return result, type_result
  end

  def is_alarm?
    b_alarm = false
    points = self.try(:points)
    points.each do |point|
      pa = point.point_alarm
      b_alarm = (pa.present?) && (pa.state == 1) && (!pa.is_checked)
      break if b_alarm
    end
    b_alarm
  end

  def alarm_count room_id, sub_system_id
    point_alarms = PointAlarm.where("room_id = #{room_id} AND sub_system_id = #{sub_system_id} AND (state != 0 OR checked_at BETWEEN '#{1.day.ago.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{DateTime.now.strftime("%y-%m-%d %H:%M:%S")}')")
    device_ids = point_alarms.pluck(:device_id)

    return [] unless device_ids.present?
    counter = Hash.new(0)
    device_ids.each {|val| counter[val] += 1}
    results = []
    counter.each do |item|
      results << {
        device_id: item[0],
        device_name: Device.get_name(room_id, item[0]),
        alarm_count: item[-1]
      }
    end
    results = results.sort_by {|u| u[:device_name]}
  end
end
