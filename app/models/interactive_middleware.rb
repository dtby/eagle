module InteractiveMiddleware

  def init url
    @connect = Faraday.new(:url => url) do |faraday|
      faraday.request :url_encoded
      faraday.response :logger
      faraday.adapter Faraday.default_adapter
    end
  end

  def send_info(params={}, head_params={})
    remotes = Settings.weixin_remote.split(';')
    method = params[:method] || params['method']
    remotes.each do |remote|
      init remote
      result = send("use_#{method}", params, head_params)
    end
  end

  private
  def use_post(params={}, head_params={})
    data_url = params[:url] || params['url']
    request_params = params[:data] || params['data']
    response = @connect.post do |request|
      request.url data_url
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      if head_params.present?
        phone = head_params[:phone] || head_params['phone']
        token = head_params[:token] || head_params['token']
        i_type = params[:i_type] || params['i_type'] || 'User'
        request.headers["X-#{i_type}-Phone"] = phone
        request.headers["X-#{i_type}-Token"] = token
      end
      request.body = request_params.to_json
    end
    MultiJson.load(response.body)
  end

  def use_get(params={}, head_params={})
    data_url = params[:url] || params['url']
    request_params = params[:data] || params['data']
    response = @connect.get do |request|
      request.url data_url
      request.headers['Content-Type'] = 'application/json'
      request.headers['Accept'] = 'application/json'
      if head_params.present?
        phone = head_params[:phone] || head_params['phone']
        token = head_params[:token] || head_params['token']
        i_type = params[:i_type] || params['i_type'] || 'User'
        request.headers["X-#{i_type}-Phone"] = phone
        request.headers["X-#{i_type}-Token"] = token
      end
      request.body = request_params.to_json
    end
    MultiJson.load(response.body)
  end
end
