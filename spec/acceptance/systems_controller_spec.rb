require 'acceptance_helper'

resource "系统列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/systems" do
    before(:each) do
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

    response_field :id, "系统ID"
    response_field :name, "系统名"
    response_field :sub_system_name, "子系统名"


    example "获取系统列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
