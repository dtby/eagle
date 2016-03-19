require 'acceptance_helper'

resource "用户信息" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/users/:id" do
    before do
      @user = create(:user)
    end

    let(:id) { @user.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "姓名"
    response_field :phone, "手机号码"

    example "获取个人信息成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/users/update_password" do
    before do
      @user = create(:user)
    end

    let(:id) { @user.id }
    let(:password) { "987654321" }
    let(:sms_token) { "989898" }
    let(:raw_post) { params.to_json }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    parameter :password, "新密码", required: true, scope: :user
    parameter :sms_token, "短信验证码", required: true, scope: :user

    response_field :id, "用户ID"
    response_field :email, "邮件"
    response_field :name, "姓名"
    response_field :phone, "电话"
    response_field :authentication_token, "token"

    example "修改密码成功" do
      do_request
      expect(status).to eq(200)
    end
  end
end