# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SmsTokensController < ApplicationController
  
  acts_as_token_authentication_handler_for User, only: [:create]

  def create
    @result = SmsToken.new.send_to current_user.try(:phone), params[:debug]
  end

end
