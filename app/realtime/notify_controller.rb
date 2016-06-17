class NotifyController < FayeRails::Controller

  channel '/notify/**' do
    monitor :subscribe do
      puts "Client #{client_id} subscribed to #{channel}"
      matcher = /alarms_(\d+)/.match(channel)
      if matcher and matcher[1].present?
        $redis.hset 'subscribe_alarm_phone', matcher[1], 1
      end
    end
    monitor :unsubscribe do
      puts "Client #{client_id} unsubscribed from #{channel}"
      matcher = /alarms_(\d+)/.match(channel)
      if matcher and matcher[1].present?
        $redis.hdel 'subscribe_alarm_phone', matcher[1]
      end
    end
    monitor :publish do
      puts "Client #{client_id} published #{data.inspect} to #{channel}"
    end
  end
end
