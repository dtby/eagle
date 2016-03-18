require 'acceptance_helper'

resource "验证码" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/sms_tokens" do
    before do
      @user = create(:user)
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "发送结果"

    example "发送验证码成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
