class BaseController < ApplicationController
	before_action :authenticate_user!, :authenticate_and_set_room

  # 验证用户是否有访问当前机房的权限
  def authenticate_and_set_room
    # room赋值
    if params[:controller] == 'rooms' && params[:action] == 'show'
      @room = Room.where(id: params[:id]).first
    elsif params[:controller] == 'patterns'
      @room = Room.where(id: params[:room_id]).first
    end

    # room权限
    if params[:controller].include?('rooms')
      # room是否存在
      return redirect_to root_path unless @room.present?
      unless UserRoom.where(room: @room, user: current_user).first.present?
        flash[:error] = '没有权限查看当前机房信息'
        return redirect_to root_path
      end
    end
  end
end
