class ReportsController < BaseController
  def index
    start_time = DateTime.now.strftime("%Q").to_i
    @devices = @room.devices
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "ReportsController time is #{end_time-start_time}"
    #logger.info "@device is #{@device.inspect}"
    #@point_histories = PointHistory.get_point_histories(params[:start_time])
  end

  def replace_chart
    result = PointHistory.result_by_sorts(params[:start_time], params[:end_time], params[:point_id])
    @data = result[0].to_json
    p "xxxxxxxxx"
    p @data
    @time = result[1].to_json
    p @time
    @name = params[:name].to_json
    p @name
    respond_to do |format|
      format.js {}
    end
  end
end
