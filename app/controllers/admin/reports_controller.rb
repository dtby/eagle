class Admin::ReportsController < AdminBaseController

  def index
    @rooms = Room.all.pluck(:name, :id)
  end

  def create
    Point.new.update_report_show(params[:device_id], params[:report_points])
    respond_to do |format|
      format.js
    end
  end
end
