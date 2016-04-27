class ReportsController < BaseController

  def index
    # start_time = DateTime.now.strftime("%Q").to_i
    # @devices = @room.devices.includes(:points)
    @devices = @room.report_devices

    # end_time = DateTime.now.strftime("%Q").to_i
    #@point_histories = PointHistory.get_point_histories(params[:start_time])
  end

  #报表搜索结果
  def results
    start_time = params[:start_time]
    end_time   = params[:end_time]
    points = params[:points].keys.join(',')
    @result_hash = PointHistory.new.reports(start_time, end_time, points)
    respond_to do |format|
      format.js
    end
  end

  def import
    start_time = params[:start_time]
    end_time   = params[:end_time]
    points = params[:points].join(',')
    result = PointHistory.new.reports(start_time, end_time, points)

    file_name = Report.new.write_to_excel @room.id, result
    render :json => {file_name: file_name}
  end

  def get_points
    @device = Device.find(params[:device_id])
    respond_to do |format|
      format.js {}
    end
  end

end
