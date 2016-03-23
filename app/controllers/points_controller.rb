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
#  state       :boolean          default(TRUE)
#  point_type  :integer
#  max_value   :string(255)
#  min_value   :string(255)
#
# Indexes
#
#  index_points_on_device_id  (device_id)
#
# Foreign Keys
#
#  fk_rails_d6f3cdbe9a  (device_id => devices.id)
#

class PointsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:get_value_by_name]
  before_action :set_room, only: [:get_value_by_names]
  before_action :set_point, only: [:history_values]

  def get_value_by_names
    names = get_value_by_names_params[:names]
    names = names.split("|")

    @datas = {}
    @room.devices.each do |device|
      @datas[device.try(:name)] = device.points.where(name: names)
    end
  end

  def history_values
    count = params[:count] || 5
    @hash = @point.try(:history_values, count) || {}
  end

  private
  def get_value_by_names_params
    params.require(:point).permit(:names)
  end

  def set_room
    @room = Room.find_by(id: params[:room_id])
  end

  def set_point
    @point = Point.find_by(id: params[:id])
  end
end
