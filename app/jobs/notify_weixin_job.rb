class NotifyWeixinJob < ActiveJob::Base
  include InteractiveMiddleware
  queue_as :sync_info

  def perform params
    request_params = {method: 'post', url: '/receivers/fetch'}
    request_params[:data_hash] = params
    send_info(request_params, {})
  end
end
