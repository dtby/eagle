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

FactoryGirl.define do
  factory :point_alarm do
    pid 1
    comment "comment"
    alarm_value "alarm value"
    alarm_type "alarm type"
    is_checked false
    is_cleared false
    device_name "alarm device name"
  end

end
