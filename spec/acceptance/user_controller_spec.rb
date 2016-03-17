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
end