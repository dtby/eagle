require 'clockwork'
require './config/boot'
require './config/environment'
module Clockwork

  configure do |config|
    config[:sleep_timeout] = 5
    config[:logger] = Logger.new("log/clock.log")
    config[:tz] = 'EST'
    config[:max_threads] = 15
    config[:thread] = true
  end

  handler do |job|
    puts "Running #{job}"
  end

  every(3.seconds, "monitor_db.job") {
    Point.monitor_db
  }

end