require 'acceptance_helper'

resource "系统列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/systems" do
    before do
      create(:user)
      (0..3).each do |i|
        system = create(:system, sys_name: "sys_name_#{i}")
        (0..3).each do |si|
          create(:sub_system, system: system, name: "sub_system_#{i}#{si}")
        end
      end
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "用户ID"
    response_field :email, "邮箱"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :phone, "电话号码"
    response_field :name, "姓名"
    response_field :authentication_token, "鉴权Token"

    example "获取系统列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
