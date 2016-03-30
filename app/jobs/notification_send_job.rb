class NotificationSendJob < ActiveJob::Base
  queue_as :default

  def perform point_alarm
    # Do something later
    notification_to_app point_alarm
    notification_to_wechat point_alarm
  end

  def notification_to_app point_alarm
    custom_content = {
      custom_content: {
        id: point_alarm.id,
        device_name: point_alarm.device_name,
        pid: point_alarm.pid,
        state: point_alarm.state,
        created_at: point_alarm.created_at,
        updated_at: point_alarm.updated_at,
        checked_at: point_alarm.checked_at,
        is_checked: point_alarm.is_checked,
        point_id: point_alarm.point_id,
        comment: point_alarm.comment,
        type: point_alarm.type,
        meaning: point_alarm.meaning,
        alarm_value: point_alarm.alarm_value, 
      }
    }

    params = {}
    title = "告警！"
    content = "#{point_alarm.device_name}的#{point_alarm.try(:point).try(:name)}出现告警！"

    user_ids = UserRoom.where(room_id: point_alarm.room_id).pluck(:user_id).uniq

    [:android, :ios].each do |type|
      User.where(id: user_ids, os: type.to_s).each do |user|
        next unless user.present? && user.device_token.present?
        sender = Xinge::Notification.instance.send type
        response = sender.pushToSingleDevice user.device_token, title, content, params, custom_content
        puts "response is #{response.inspect}"
        logger.info "response is #{response.inspect}"
      end
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
