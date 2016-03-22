require 'acceptance_helper'

resource "验证码" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/sms_tokens" do
    before do
      @user = create(:user)
    end

    response_field :result, "发送结果"

    parameter :debug, "请忽略", required: false
    parameter :phone, "为生成文档加的参数", required: false, scope: :sms_token

    let(:debug) { true }
    let(:phone) { "18516107607" }
    let(:raw_post) { params.to_json }

    example "发送验证码成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
