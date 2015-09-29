class DevicesController < BaseController

  def show
    @device = Device.where(id: params[:id]).first
  end
end
