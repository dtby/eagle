class ReportsController < BaseController
  def index
    @devices = @room.devices
  end

  def replace_chart
    @data = params[:data].to_json
    @time = params[:time].to_json
    respond_to do |format|
      format.js {}
    end
  end
end
