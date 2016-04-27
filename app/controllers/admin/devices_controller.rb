class Admin::DevicesController < AdminBaseController

  def index
    room = Room.find_by_id(params[:room_id])
    @devices = room.devices.pluck(:id, :name)
  end
end
