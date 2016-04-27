class Admin::PointsController < AdminBaseController

  def index
    device = Device.find_by_id(params[:device_id])
    @points = device.points.pluck(:id, :name, :s_report)
  end
end
