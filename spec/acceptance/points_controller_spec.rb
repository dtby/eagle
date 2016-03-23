require 'acceptance_helper'

resource "点列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/rooms/:id/points/get_value_by_names" do
    before do
      @room = create(:room)
      (0..3).each do |di|
        device = create(:device, name: "device_#{di}", room: @room)
        (0..3).each do |pi|
          create(:point, device: device, name: "point_#{pi}", point_index: "#{di}#{pi}")
          $redis.hset "eagle_point_value", "#{di}#{pi}", pi.to_s
        end
      end
    end

    parameter :names, "点名字", required: true, scope: :point

    let(:id) { @room.id }
    let(:names) { "point_1|point_2" }
    let(:raw_post) { params.to_json }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :device_name, "设备名字"
    response_field :name, "点名字"
    response_field :value, "点的值"

    example "获取点列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/rooms/:room_id/points/:id/history_values" do
    before do
      @room = create(:room)
      (0..3).each do |di|
        device = create(:device, name: "device_#{di}", room: @room)
        (0..3).each do |pi|
          create(:point, device: device, name: "point_#{pi}", point_index: "#{di}#{pi}")
        end
      end
    end

    parameter :count, "最近count个小时的值（默认为5）", required: false

    let(:id) { Point.last.id }
    let(:room_id) { @room.id }
    let(:count) { 4 }
    let(:raw_post) { params.to_json }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :time, "时间点"
    response_field :value, "点的值"

    example "获取点历史值成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
