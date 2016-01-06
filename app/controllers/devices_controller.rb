class DevicesController < BaseController
  
  before_action :authenticate_user!
  def show
    @room = Room.where(id: params[:room_id]).first
    @device = Device.includes(:points).where(id: params[:id]).first
    @points = @device.points_group
    @exclude_points = @device.pattern.getting_exclude_points
  end
end
