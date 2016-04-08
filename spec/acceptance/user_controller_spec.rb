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
    let(:phone) { @user.phone }
    let(:sms_token) { "989899" }
    let(:raw_post) { params.to_json }

    parameter :password, "新密码", required: true, scope: :user
    parameter :phone, "电话号码", required: true, scope: :user
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

  post "/users/update_device" do
    before do
      @user = create(:user)
    end

    let(:os) { "ios" }
    let(:device_token) { "abcd.1234" }
    let(:raw_post) { params.to_json }

    parameter :os, "操作系统(android, ios)", required: true, scope: :user
    parameter :device_token, "设备标识", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "用户ID"
    response_field :email, "邮件"
    response_field :name, "姓名"
    response_field :phone, "电话"
    response_field :authentication_token, "token"
    response_field :os, "操作系统"
    response_field :device_token, "设备标识"

    example "修改设备信息成功" do
      do_request
      puts "response is #{response_body}"
      expect(status).to eq(200)
    end
  end
end