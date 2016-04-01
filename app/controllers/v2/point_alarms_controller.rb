class V2::PointAlarmsController < BaseController
  acts_as_token_authentication_handler_for User, only: [:show]

  def count
    @results = {}
    level = params[:level]
    id = params[:id]
    @results = send("#{level}_alarms", id)
    # if params[:room_id].present? && !(params[:sub_system_id].present?)
    #
    #
    # elsif params[:sub_system_id].present?
    #
    #   point_alarms = PointAlarm.where("room_id = #{params[:room_id]} AND sub_system_id = #{params[:sub_system_id]} AND (state != 0 OR checked_at BETWEEN '#{1.day.ago.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{DateTime.now.strftime("%y-%m-%d %H:%M:%S")}')")
    #   device_ids = point_alarms.pluck(:device_id)
    #
    #   return unless device_ids.present?
    #   ids = device_ids.uniq
    #   device_names = []
    #   ids.each do |id|
    #     device_names << Device.find(id).try(:name)
    #   end
    #   ids = device_ids.uniq.collect { |di| device_ids.count(di) }
    #
    #   @results = Hash[device_names.zip(ids)]
    # end
  end

  private
  def room_alarms id
    Room.new.alarms id
  end

  def device_alarms id
    
  end
end
