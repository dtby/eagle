class Admin::PointsController < Admin::BaseController

  def index
    device = Device.find_by_id(params[:device_id])
    @points = device.points.where("name not like '告警-%'").pluck(:id, :name, :s_report)
  end

  def show
    @point = Point.find_by(id: params[:id])
  end

  def update
    @point = Point.find_by(id: params[:id])
    @point.update_params(point_params);
    @device = @point.device
    @room = @device.room
  end

  private
  def point_params
    params.require(:point).permit(:name, :point_type, :u_up_value, :max_value, 
      :min_value, :d_down_value, :s_report, :main_alarm_show, :comment)
  end
end
