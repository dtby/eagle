require 'acceptance_helper'

resource "设备列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/rooms/:id/devices" do
    before do
      create(:user)
      @room = create(:room)
      (0..3).each do |i|
        device = create(:device, name: "device_#{i}", room: @room)
        (0..3).each do |i|
          create(:point, device: device, name: "point_#{i}")
        end
      end
    end

    let(:id) { @room.id }
    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    
    response_field :id, "设备ID"
    response_field :name, "设备名"

    example "获取设备列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/rooms/:id/devices/search" do
    before do
      create(:user)
      @room = create(:room)
      sub_system = create(:sub_system, name: "配电系统")
      (0..1).each do |pattern_id|
        pattern = create(:pattern, name: "pattern_#{pattern_id}", sub_system: sub_system)
        (0..2).each do |device_id|
          device = create(:device, name: "device_#{device_id}", room: @room, pattern: pattern)
          (0..2).each do |point_id|
            create(:point, device: device, name: "A相电压")
          end
        end
      end
    end

    let(:id) { @room.id }

    let(:sub_sys_name) { "配电系统" }
    let(:raw_post) { params.to_json }

    parameter :sub_sys_name, "子系统名", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    
    response_field :id, "设备ID"
    response_field :name, "设备名"
    response_field :point_id, "点ID"
    response_field :point_name, "点名字"
    response_field :point_value, "点的值"

    example "获取设备列表成功（By子系统名）" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/rooms/:room_id/devices/:id" do
    before do
      create(:user)
      @room = create(:room)
      (0..3).each do |i|
        device = create(:device, name: "device_#{i}", room: @room)
        (0..3).each do |i|
          create(:point, device: device, name: "point_#{i}")
        end
      end
      create(:attachment, tag: "device_0", room: @room)
    end

    let(:room_id) { @room.id }
    let(:id) { Device.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    
    response_field :id, "设备ID"
    response_field :name, "设备名"
    response_field :pic, "图片路径"

    example "获取设备相关点位信息成功" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/v2/rooms/:room_id/devices/:id" do
    before do
      create(:user)
      @room = create(:room)
      types = ["number_type", "status_type", "alarm_type"]
      (0..3).each do |i|
        device = create(:device, name: "device_#{i}", room: @room)
        (0..3).each do |i|
          point = create(:point, device: device, name: "point_#{i}")
          point.tag_list.add types[i]
          point.save
        end
      end
      create(:attachment, tag: "device_0", room: @room)
    end

    let(:room_id) { @room.id }
    let(:id) { Device.first.id }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]
    
    response_field :id, "设备ID"
    response_field :name, "设备名"
    response_field :pic, "图片路径"
    with_options :scope => :number_type do
      response_field :name, "（数值类型的）点名"
      response_field :value, "（数值类型的）点的值"
      response_field :meaning, "（数值类型的）点值的意义"
      response_field :color, "（数值类型的）字体颜色"
    end
    with_options :scope => :status_type do
      response_field :name, "（状态类型的）点名"
      response_field :value, "（状态类型的）点的值"
      response_field :meaning, "（状态类型的）点值的意义"
      response_field :color, "（状态类型的）字体颜色"
    end
    with_options :scope => :alarm_type do
      response_field :name, "（告警类型的）点名"
      response_field :value, "（告警类型的）点的值"
      response_field :meaning, "（告警类型的）点值的意义"
      response_field :color, "（告警类型的）字体颜色"
    end
    with_options :scope => :alarm do
      response_field :name, "点名"
      response_field :value, "告警值"
      response_field :type, "告警类型"
    end

    example "获取点位信息（分组）成功（Version: 2）" do
      do_request
      expect(status).to eq(200)
    end
  end

end
