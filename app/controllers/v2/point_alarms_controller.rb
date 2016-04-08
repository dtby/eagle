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
    results = []
    point_alarms = PointAlarm.where("room_id = #{id} AND (state != 0 OR checked_at BETWEEN '#{1.day.ago.strftime("%Y-%m-%d %H:%M:%S")}' AND '#{DateTime.now.strftime("%y-%m-%d %H:%M:%S")}')")

    sub_system_ids = point_alarms.pluck(:sub_system_id)

    return [] unless sub_system_ids.present?
    counter = Hash.new(0)
    sub_system_ids.each {|val| counter[val] += 1}
    counter.each do |item|
      results << {
        device_id: item[0],
        device_name: SubSystem.find(item[0]).try(:name),
        alarm_count: item[-1]
      }
    end
    # ids = sub_system_ids.uniq
    # sub_system_names = []
    # ids.each do |id|
    #   sub_system_names << SubSystem.find(id).try(:name)
    # end
    # ids = ids.collect { |ssi| sub_system_ids.count(ssi) }
    #
    # results = Hash[sub_system_names.zip(ids)]

  end
end
