class AlarmProcessJob < ActiveJob::Base
  queue_as :default

  def perform(point_index, name)
    # Do something later
    puts "point name is #{name}, point index is #{point_index}"
    config = Rails.configuration.database_configuration
    ActiveRecord::Base.establish_connection config["dap"]
    sql = "UPDATE dap.cos SET User = '#{name}' WHERE PointID=#{point_index} ORDER BY ADate DESC, ATime DESC, AMSecond DESC LIMIT 1"
    records_array = ActiveRecord::Base.connection.update(sql)
  end
end