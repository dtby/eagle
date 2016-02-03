class ReportsController < BaseController
  def index
    start_time = DateTime.now.strftime("%Q").to_i
    @devices = @room.devices
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "ReportsController time is #{end_time-start_time}"
    logger.info "@device is #{@device.inspect}"
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
