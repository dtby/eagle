class V2::PointAlarmsController < BaseController
  acts_as_token_authentication_handler_for User, only: [:show]

  def count
    @results = {}
    level = params[:level]
    room_id = params[:room_id]
    sub_system_id = params[:sub_system_id]
    @results = send("#{level}_alarms", {room_id: room_id, sub_system_id: sub_system_id})
  end

  private
  def room_alarms ids
    Room.new.alarm_count ids[:room_id]
  end

  def device_alarms ids
    Device.new.alarm_count ids[:room_id], ids[:sub_system_id]
  end
end
