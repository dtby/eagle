class AlarmProcessJob < ActiveJob::Base
  queue_as :default

  def perform(name, seconds)
    # Do something later
    puts "args is #{name}, seconds is #{seconds}"
  end
end
