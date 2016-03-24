class ReportsController < BaseController
  def index
    start_time = DateTime.now.strftime("%Q").to_i
    @devices = @room.devices
    end_time = DateTime.now.strftime("%Q").to_i
    logger.info "ReportsController time is #{end_time-start_time}"
    logger.info "@device is #{@device.inspect}"
    #@point_histories = PointHistory.get_point_histories(params[:start_time])
  end

  #报表搜索结果
  def results
    result = PointHistory.result_by_sorts(params[:start_time], params[:end_time], params[:point_id])
    @data = result[0].map{|x| '%.1f' % x }.to_json
    @time = result[1].to_json
    @name = params[:name].to_json
    @point_id = params[:point_id]

    point_histories = PointHistory.where({id: result[2], point_id: params[:point_id]})
    p "xxxxxxxxxx"
    p point_histories
    p "yyyyyyyyy"

    respond_to do |format|
      format.html
      format.xls{
        send_data( xls_content_for(point_histories),
          :type => "text/excel;charset=utf-8; header=present",
          :filename => "#{params[:name]}报表(#{Time.now.strftime("%F %H%M%S")}).xls" )
      }
    end
  end

  def get_points
    @device = Device.find(params[:device_id])
    respond_to do |format|
      format.js {}
    end
  end

  private
  # 导出为xls
  def xls_content_for(objs)
    xls_report = StringIO.new
    book = Spreadsheet::Workbook.new
    sheet1 = book.create_worksheet :name => "报表"

    gray = Spreadsheet::Format.new :color => :gray, :weight => :bold, :size => 10
    sheet1.row(0).default_format = gray

    sheet1.row(0).concat %w{设备名 点名 时间 值}
    count_row = 1
    objs.each do |obj|
      sheet1[count_row, 0] = obj.try(:device).try(:name)
      sheet1[count_row, 1] = obj.point_name
      sheet1[count_row, 2] = obj.created_at.strftime("%Y-%m-%d %H:%M:%S")
      sheet1[count_row, 3] = obj.point_value
      count_row += 1
    end

    book.write xls_report
    xls_report.string
  end
end
