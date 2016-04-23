class BaseController < ApplicationController
  before_action :authenticate_user!, :authenticate_and_set_room, if: lambda { |controller| controller.request.format.html?}
  before_action :list_alerts

  before_action :validate_mac_code
  
  private
  def validate_mac_code
    if MacCode.encrypt_macaddr !=  MacCode.get_lience
      return render text: "权限验证失败，详情联系开系统提供商！"
    end
  end
  
  # 验证用户是否有访问当前机房的权限
  def authenticate_and_set_room
    # room赋值
    if params[:controller] == 'rooms' && params[:action] == 'show'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'rooms' && params[:action] == 'alert'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'rooms' && params[:action] == 'checked_alert'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'rooms' && params[:action] == 'video'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'rooms' && params[:action] == 'pic'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'reports' && params[:action] == 'index'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'devices'
      @room = Room.where(id: params[:room_id]).first
    end

    # room权限
    if params[:controller] == "rooms" || params[:controller] == "devices"
      # room是否存在
      return redirect_to root_path unless @room.present?
      unless UserRoom.where(room: @room, user: current_user).first.present?
        flash[:error] = '没有权限查看当前机房信息'
        return redirect_to root_path
      end
    end
  end
  private
  def list_alerts
    if params[:room_id].present?
      @room = Room.where(id: params[:room_id]).first
    elsif params[:id].present?
      @room = Room.where(id: params[:id]).first
    end
    if @room.present?
      @alerts = PointAlarm.unchecked.active.get_alarm_point_by_room(@room.id)
    else
      @alerts = {}
    end
  end
end
