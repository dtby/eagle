require 'clockwork'
require './config/boot'
require './config/environment'
module Clockwork

  handler do |job|
    puts "Running #{job}"
  end

  every(3.seconds, "monitor_db.job") {
    Point.monitor_db
  }

end