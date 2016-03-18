# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SmsToken < ActiveRecord::Base
  
  def send_to phone
    return false unless Phonelib.valid_for_country? phone, 'CN'

    company = "艾格瑞德"
    token = (0..9).to_a.sample(4).join
    # ChinaSMS.use :yunpian, password: "526b4de5ac7b6ea21446ea7917860946"
    # result = ChinaSMS.to phone, {company: company, code: token}, {tpl_id: 2}
    # logger.info "sms_token_send result is #{result}"
    save_to_redis phone, token
    true
  end

  private

    def save_to_redis phone, token
      sms_token_info = { token: token, time: DateTime.now.to_s }
      $redis.hset "eagle_sms_token_cache", phone, sms_token_info.to_json
    end
end
