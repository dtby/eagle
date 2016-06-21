class Admin::DevicesController < AdminBaseController

  def index
    @room = Room.find_by_id(params[:room_id])
    @devices = @room.devices.pluck(:id, :name)
    if request.format.html?
      device_id = params[:device_id] || @devices.first.first
      @points = Point.where("device_id = ?", device_id).paginate(page: params[:page], per_page: 20)
    end
  end

end
