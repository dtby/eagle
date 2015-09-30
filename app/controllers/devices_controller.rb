class DevicesController < BaseController

  def show
    @device = Device.includes(:points).where(id: params[:id]).first
    @exclude_points = @device.pattern.getting_exclude_points
  end
end
