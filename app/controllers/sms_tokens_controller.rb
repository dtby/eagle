# == Schema Information
#
# Table name: sms_tokens
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class SmsTokensController < ApplicationController
  

  def create
    @result = SmsToken.new.send_to create_params[:phone], params[:debug]
  end

  private

    def create_params
      params.require(:sms_token).permit(:phone)      
    end
end
