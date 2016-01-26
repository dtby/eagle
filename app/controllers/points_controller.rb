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

class PointsController < ApplicationController
  acts_as_token_authentication_handler_for User, only: [:get_value_by_name]
  before_action :set_device, only: [:get_value_by_names]

  def get_value_by_names
    
    names = get_value_by_names_params[:names]
    names = names.split("|")

    @values = {}
    names.each do |name|
      point = @device.points.find_by(name: name)
      next unless point.present?
      @values[point.name] = point.value
    end
  end

  private
    
    def get_value_by_names_params
      params.require(:point).permit(:names)
    end

    def set_device
      @device = Device.find_by(id: params[:id])
    end

end
