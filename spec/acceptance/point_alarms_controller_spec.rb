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

    response_field :id, "告警ID"
    response_field :state, "告警状态"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :is_checked, "是否确认"
    response_field :point_id, "点ID"

    example "获取告警列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/point_alarms/:point_id/checked" do 
    before do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |i|
        device = create(:device, room: @room, name: "device#{i}")
        (0..i).each do |index|
          point = create(:point, device: device)
          create(:point_alarm, point: point)
          @points << point
        end
        
      end
    end

    let(:point_id) { @points.last.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "处理结果"

    example "标记告警为已处理成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/point_alarms/:point_id/unchecked" do 
    before do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |i|
        device = create(:device, room: @room, name: "device#{i}")
        (0..i).each do |index|
          point = create(:point, device: device)
          create(:point_alarm, point: point)
          @points << point
        end
        
      end
    end

    let(:point_id) { @points.last.id }

    parameter :point_id, "点ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "处理结果"

    example "标记告警为未处理成功" do
      do_request
      expect(status).to eq(200)
    end
  end
end
