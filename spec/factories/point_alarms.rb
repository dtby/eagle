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
#  comment    :string(255)
#  room_id    :integer
#  device_id  :integer
#
# Indexes
#
#  index_point_alarms_on_device_id  (device_id)
#  index_point_alarms_on_point_id   (point_id)
#  index_point_alarms_on_room_id    (room_id)
#
# Foreign Keys
#
#  fk_rails_72669ae946  (room_id => rooms.id)
#  fk_rails_776a91d70e  (device_id => devices.id)
#  fk_rails_de15df710f  (point_id => points.id)
#

FactoryGirl.define do
  factory :point_alarm do
    pid 1
state 1
  end

end
