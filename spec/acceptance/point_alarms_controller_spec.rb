require 'acceptance_helper'

resource "告警相关" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/rooms/:id/point_alarms" do
    before do
      create(:user)
      @room = create(:room)

      (0..3).each do |i|
        device = create(:device, room: @room, name: "device#{i}")
        (0..i).each do |index|
          point = create(:point, device: device)
          point_alarm = create(:point_alarm, point: point)
        end
        
      end
    end

    let(:id) { @room.id }

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

    example "获取告警列表成功" do
      puts "header is #{headers}"
      do_request
      puts "response_field is #{response_body}"
      expect(status).to eq(200)
    end
  end

end
