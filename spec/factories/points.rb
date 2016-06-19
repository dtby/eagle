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
#
# Indexes
#
#  index_points_on_device_id    (device_id)
#  index_points_on_point_index  (point_index)
#

FactoryGirl.define do
  factory :point do
    point_index "123456"
  end

end
