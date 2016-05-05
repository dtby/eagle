class V2::DevicesController < BaseController
  acts_as_token_authentication_handler_for User, only: [:show]
  def show
    @device = Device.find_by(id: params[:id])
    @points = @device.try(:points).try(:order, 'name')#.try(:to_a)
    # @points = @points.sort_by {|p| p.name[/\d+/].to_i }
    @alarms, @alarm_types = @device.alarm_group
    #通过设备名称获取背景图片
    # @attachment = @room.attachments.where("tag like ?", "%#{@device.name}%").first
  end
end
