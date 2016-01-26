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
  before_action :authenticate_user!, if: lambda { |controller| controller.request.format.html? }
  acts_as_token_authentication_handler_for User, only: [:search]

  def index
    room = Room.where(id: params[:room_id]).first
    @devices = room.devices
  end

  def show
    @room = Room.where(id: params[:room_id]).first
    @device = Device.includes(:points).where(id: params[:id]).first
    @alarms = Device.find(params[:id]).alarms.sort_by{|x| x.device_name.gsub(/[^0-9]/, '').to_i}
    @points = @device.points_group
    @exclude_points = @device.pattern.getting_exclude_points
  end

  def search
    sub_system = SubSystem.find_by(name: params[:sub_sys_name])
    if sub_system.present?
      patterns = sub_system.try(:patterns)
      @devices = []
      if patterns.present?
        patterns.each do |pattern|
          devices = pattern.devices
          next unless devices.present?
          @devices.concat devices.includes(:points).where(room_id: params[:room_id])
        end
      end
    end
  end

end
