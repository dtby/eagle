require 'acceptance_helper'

resource "用户鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/users/sign_in" do
    before do
      @user = create(:user)
    end

    parameter :phone, "手机号码", required: true, scope: :user
    parameter :password, "登录密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

    response_field :id, "用户ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :name, "姓名"
    response_field :authentication_token, "鉴权Token"

    example "用户登录成功" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/check_phone/auth" do
    before do
      @user = create(:user)
    end

    parameter :phone, "手机号码", required: true, scope: :check_phone

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }
    let(:raw_post) { params.to_json }

    response_field :id, "用户ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :name, "姓名"
    response_field :authentication_token, "鉴权Token"

    example "获取用户token成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
