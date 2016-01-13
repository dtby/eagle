class ReportsController < BaseController
  def index
    @devices = @room.devices
    #@point_histories = PointHistory.get_point_histories(params[:start_time])
  end

  def replace_chart
    @data = params[:data].to_json
    @time = params[:time].to_json
    @name = params[:name].to_json
    respond_to do |format|
      format.js {}
    end
  end
end
