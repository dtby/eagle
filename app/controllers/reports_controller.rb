class ReportsController < BaseController
  def index
    @devices = @room.devices
  end
end
