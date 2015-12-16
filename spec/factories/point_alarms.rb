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

FactoryGirl.define do
  factory :point_alarm do
    pid 1
state 1
  end

end
