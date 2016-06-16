module FayeServer

  class Common
    def self.faye_url
      "http://localhost:3000/faye"
    end
  end

  class Push
    def self.broadcast(channel, data)
      faye_url = FayeServer::Common.faye_url
      message = {:channel => channel, :data => data }  
      uri = URI.parse(faye_url)  
      Net::HTTP.post_form(uri, :message => message.to_json)  
    end
  end
end
