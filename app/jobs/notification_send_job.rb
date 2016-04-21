class NotificationSendJob < ActiveJob::Base
  queue_as :message

  def perform point_alarm_id
    # Do something later
    logger.info "NotificationSendJob process start #{point_alarm_id}"

    config = Rails.configuration.database_configuration
    ActiveRecord::Base.establish_connection config["#{Rails.env}"]

    point_alarm = PointAlarm.find_by(id: point_alarm_id)
    return unless point_alarm.present?

    begin
      notification_to_app point_alarm
    rescue Exception => e
      logger.info "notification_to_app exception is #{e}"
    end

    begin
      notification_to_wechat point_alarm
    rescue Exception => e
      logger.info "notification_to_wechat exception is #{e}"
    end
    
    logger.info "NotificationSendJob process end #{point_alarm_id}"
    nil
  end

  def notification_to_app point_alarm
    # user_ids = UserRoom.where(room_id: point_alarm.room_id).pluck(:user_id).uniq
    # user_infos = User.where(id: user_ids).pluck(:phone, :device_token, :os)

    # size = user_infos.size
    # user_infos.each_with_index do |user_info, index|
    #   next unless user_info[1].present? && user_info[2].present?
    #   puts "phone is #{user_info[0]}"
    #   xinge_send point_alarm, user_info[1], user_info[2]
    # end
    tag_list = [point_alarm.try(:room).try(:name)]
    [:ios, :android].each do |type|
      point_alarm.notification_to_app type
    end
  end


  def notification_to_wechat point_alarm
    conn = Faraday.new(:url => "http://115.29.211.21/") do |faraday|
      faraday.request  :url_encoded
      faraday.adapter  Faraday.default_adapter
    end

    body = {
      alarm: {
        id: point_alarm.id,
        device_name: point_alarm.try(:device).try(:name),
        pid: point_alarm.pid,
        state: point_alarm.state,
        room_id: point_alarm.device.room_id,
        created_at: point_alarm.created_at,
        updated_at: point_alarm.updated_at,
        checked_at: point_alarm.checked_at,
        is_checked: point_alarm.is_checked,
        point_id: point_alarm.point_id,
        point_name: point_alarm.try(:point).try(:name),
        comment: point_alarm.comment,
        type: point_alarm.get_type,
        meaning: point_alarm.meaning,
        alarm_value: point_alarm.alarm_value
      }
    }

    response = conn.post '/alarms/fetch', body, Accept: "application/json"
  end
end
