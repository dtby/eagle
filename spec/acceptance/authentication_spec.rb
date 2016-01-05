require 'acceptance_helper'

resource "用户鉴权" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/users" do
    parameter :phone, "用户注册的手机号码", required: true, scope: :user
    parameter :password, "用户注册的密码", required: true, scope: :user
    parameter :sms_token, "用户注册的短消息验证码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { sms_attrs[:token] }
    let(:raw_post) { params.to_json }

    response_field :id, "消费者ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "用户注册成功" do
      create :sms_token
      do_request
      expect(status).to eq(201)
    end

    example "用户注册失败（短信验证码错误）" do
      create :sms_token, token: "654321"
      do_request
      expect(status).to eq(422)
    end

    example "用户注册失败（短信验证码不存在）" do
      do_request
      expect(status).to eq(422)
    end
  end

  post "/users" do
    parameter :phone, "用户注册的手机号码", required: true, scope: :user
    parameter :password, "用户注册的密码", required: true, scope: :user
    parameter :sms_token, "用户注册的短消息验证码", required: true, scope: :user
    parameter :user_source, "用户注册来源类型（0：商户，1：用户）", required: true, scope: :user
    parameter :source_id, "用户注册来源ID", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { sms_attrs[:token] }
    let(:user_source) { 1 }
    let(:source_id) { 100 }
    let(:raw_post) { params.to_json }

    response_field :id, "消费者ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "用户注册成功(带用户来源)" do
      create :sms_token
      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do
    before do
      merchant = create(:merchant)
      @user = create(:user)
      bank = create(:bank)
      bank_cards = create_list(:bank_card, 3, bank_card_type: 0, bank_id: bank.id)
      @user.customer.bank_cards = bank_cards
      @user.customer.follow! merchant
    end

    parameter :phone, "用户登录的手机号码", required: true, scope: :user
    parameter :password, "用户登录密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

    response_field :id, "消费者ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :authentication_token, "鉴权Token"

    example "用户登录成功" do
      do_request
      expect(status).to eq(201)
    end
  end

  post "/users/sign_in" do

    parameter :phone, "用户登录的手机号码", required: true, scope: :user
    parameter :password, "用户登录的密码", required: true, scope: :user

    user_attrs = FactoryGirl.attributes_for :user
    let(:password) { user_attrs[:password] }
    let(:raw_post) { params.to_json }

    example "用户登录失败" do
      do_request
      expect(status).to eq(401)
    end
  end

  get "/check_user" do

    parameter :phone, "用户注册的手机号码"

    response_field :exists, "用户是否已经注册"
    response_field :reset, "是否调用重置密码接口"
    
    user_attrs = FactoryGirl.attributes_for :user
    let(:phone) { user_attrs[:phone] }

    example "用户已经注册" do
      create :user
      do_request
      expect(status).to eq(200)
      # expect(response_body).to eq({exists: true}.to_json)
    end

    example "用户未注册" do
      do_request
      expect(status).to eq(200)
      # expect(response_body).to eq({exists: false}.to_json)
    end

  end

  post "/check_user/reset" do
    before do
      @user = create(:user)
    end

    parameter :phone, "用户注册的手机号码"
    parameter :password, "新修改的密码"
    parameter :sms_token, "短信验证码"

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { "989898" }
    let(:raw_post) { params.to_json }

    example "修改用户密码成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/check_user/reset" do
    before do
      @user = create(:user)
    end

    parameter :phone, "用户注册的手机号码"
    parameter :password, "新修改的密码"
    parameter :sms_token, "短信验证码"

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { user_attrs[:phone] }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { "111" }
    let(:raw_post) { params.to_json }

    example "修改用户密码失败（短信验证码不正确）" do
      do_request
      expect(status).to eq(422)
    end
  end

  post "/check_user/reset" do
    before do
      @user = create(:user)
    end

    parameter :phone, "用户注册的手机号码"
    parameter :password, "新修改的密码"
    parameter :sms_token, "短信验证码"

    user_attrs = FactoryGirl.attributes_for :user
    sms_attrs = FactoryGirl.attributes_for :sms_token

    let(:phone) { "111" }
    let(:password) { user_attrs[:password] }
    let(:sms_token) { "111" }
    let(:raw_post) { params.to_json }

    example "修改用户密码失败（用户不存在）" do
      do_request
      expect(status).to eq(422)
    end
  end
end
