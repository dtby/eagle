class NotifyWeixinJob < ActiveJob::Base
  include InteractiveMiddleware
  queue_as :sync_info

  def perform params
    type = params[:type] || params['type']
    data = params[:data] || params['data']
    params[:method] = 'post'
    params[:url] = '/receivers/fetch'
    send_info(params, {})
  end
end
