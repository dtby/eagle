class NotificationSendJob < ActiveJob::Base
  queue_as :message

  def perform point_alarm_id 
    # Do something later
    logger.info "NotificationSendJob process start #{point_alarm_id}"

    # config = Rails.configuration.database_configuration
    # ActiveRecord::Base.establish_connection config["#{Rails.env}"]

    point_alarm = PointAlarm.find_by(id: point_alarm_id)
    return unless point_alarm.present?

    logger.info "notification point_alarm is:#{point_alarm.inspect}"

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
    tag_list = [point_alarm.try(:room).try(:name)]
    [:ios, :android].each do |type|
      point_alarm.notification_to_app type
    end
  end


  def notification_to_wechat point_alarm
    point_alarm.notification_to_wechat
  end
end
