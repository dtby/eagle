class AlarmProcessJob < ActiveJob::Base
  queue_as :alarm

  def perform(alarm, name)
    # Do something later
    logger.info "alarm: ============================="
    logger.info "#{alarm.to_json}"
    point_index = alarm.try(:point).try(:point_index)
    return if point_index.blank?
    config = Rails.configuration.database_configuration
    ActiveRecord::Base.establish_connection config["dap"]
    table_name = ''
    if alarm.alarm_type == '越限告警'
      table_name = 'alm'
    elsif alarm.alarm_type == '开关量告警'
      table_name = 'cos'
    else
      return
    end
        
    sql = "UPDATE dap.#{table_name} SET User = '#{name}' WHERE PointID=#{point_index} ORDER BY ADate DESC, ATime DESC, AMSecond DESC LIMIT 1"
    records_array = ActiveRecord::Base.connection.update(sql)
  end
end
