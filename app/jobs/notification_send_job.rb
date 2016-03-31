class NotificationSendJob < ActiveJob::Base
  queue_as :message

  def perform point_alarm_id
    # Do something later
    point_alarm = PointAlarm.find_by(id: point_alarm_id)
    return unless point_alarm.present?
    [:android, :ios].each do |type|
      user_ids = UserRoom.where(room_id: point_alarm.room_id).pluck(:user_id).uniq
      puts user_ids
      user_ids.each do |user_id|
        notification_to_app point_alarm, user_id, type
      end
    end
    notification_to_wechat point_alarm
    nil
  end

  def notification_to_app point_alarm, user_id, type

    user = User.find(user_id)
    return unless user.present? && user.device_token.present?  
    return unless user.os == type.to_s
    custom_content = {
      custom_content: {
        id: point_alarm.id,
        device_name: point_alarm.try(:device).try(:name),
        pid: point_alarm.pid,
        state: point_alarm.state,
        created_at: point_alarm.created_at,
        updated_at: point_alarm.updated_at,
        checked_at: point_alarm.checked_at,
        is_checked: point_alarm.is_checked,
        point_id: point_alarm.point_id,
        comment: point_alarm.comment,
        type: point_alarm.alarm_type,
        meaning: point_alarm.meaning,
        alarm_value: point_alarm.alarm_value, 
      }
    }

    params = {}
    title = "告警！"
    content = "#{point_alarm.try(:device).try(:name)}的#{point_alarm.try(:point).try(:name)}出现告警！"

    sender = Xinge::Notification.instance.send type
    begin
      response = sender.pushToSingleDevice user.device_token, title, content, params, custom_content
    rescue Exception => e
      puts "Exception is #{e.inspect}"
    ensure
      puts "response is #{response.inspect}, params is #{user.phone}"
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
        room_id: point_alarm.room_id,
        device_name: point_alarm.device.name, 
        created_at: point_alarm.created_at,
        point_id: point_alarm.point_id,
        comment: point_alarm.comment
      }
    }

    response = conn.post '/alarms/fetch', body, Accept: "application/json"
  end
end
