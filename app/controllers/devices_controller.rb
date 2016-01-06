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

class DevicesController < BaseController

  def show
    @room = Room.where(id: params[:room_id]).first
    @device = Device.includes(:points).where(id: params[:id]).first
    @points = @device.points_group
    @exclude_points = @device.pattern.getting_exclude_points
  end
end
