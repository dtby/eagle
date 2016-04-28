class Admin::PointsController < AdminBaseController

  def index
    device = Device.find_by_id(params[:device_id])
    @points = device.points.where("name not like '告警-%'").pluck(:id, :name, :s_report)
  end
end
