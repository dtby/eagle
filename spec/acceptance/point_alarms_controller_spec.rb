require 'acceptance_helper'

resource "告警相关" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/rooms/:id/point_alarms" do
    before(:each) do
      create(:user)
      @room = create(:room)
      @sub_system = create(:sub_system)
      pattern = create(:pattern, sub_system: @sub_system)
      (0..3).each do |i|
        device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
        (0..i).each do |index|
          point = create(:point, device: device, name: "point_#{index}_#{i}")
          point_alarm = create(:point_alarm, point: point, is_checked: true, room: @room, device: point.device)
        end
        
      end
    end

    let(:id) { @room.id }
    let(:checked) { "0" }
    let(:sub_system) { @sub_system.name }
    let(:page) { 1 }
    let(:per_page) { 1 }

    parameter :checked, "告警是否已经解除(0:全部，1:已经确认, 2:未结束。默认为2)"
    parameter :sub_system, "子系统名", required: true
    parameter :page, "页数", required: false
    parameter :per_page, "每页显示的条数", required: false

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "告警ID"
    response_field :device_name, "设备名"
    response_field :state, "告警状态"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :is_checked, "是否确认"
    response_field :point_id, "点ID"
    response_field :comment, "说明"
    response_field :checked_user, "确认人"

    example "获取告警列表成功（基于机房）" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/devices/:device_id/point_alarms" do
    before(:each) do
      create(:user)
      @room = create(:room)
      @sub_system = create(:sub_system)
      pattern = create(:pattern, sub_system: @sub_system)
      (0..3).each do |i|
        device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
        (0..i).each do |index|
          point = create(:point, device: device)
          point_alarm = create(:point_alarm, point: point, is_checked: true, room: @room, device: point.device)
        end
        
      end
    end

    let(:device_id) { 1 }
    let(:checked) { "1" }

    parameter :checked, "告警是否已经解除(0:全部，1:已经确认, 2:未结束。默认为2)"

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "告警ID"
    response_field :device_name, "设备名"
    response_field :state, "告警状态"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :is_checked, "是否确认"
    response_field :point_id, "点ID"
    response_field :comment, "说明"
    response_field :checked_user, "确认人"

    example "获取告警列表成功（基于设备）" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/point_alarms/:point_id/checked" do 
    before(:each) do
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
    before(:each) do
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

  post "/rooms/:room_id/point_alarms/count" do 
    before(:each) do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |ssi|
        sub_system = create(:sub_system, name: "sub_system_#{ssi}")
        (0..2).each do |pi|
          pattern = create(:pattern, sub_system: sub_system, name: "pattern_#{pi}_#{ssi}")
          (0..3).each do |i|
            device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
            (0..i).each do |index|
              point = create(:point, device: device)
              create(:point_alarm, point: point, device: point.device, sub_system: point.device.pattern.sub_system, room: @room)
              @points << point
            end
          end
        end
      end
    end

    let(:room_id) { @room.id }

    parameter :room_id, "机房ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "处理结果"

    example "获取机房下子系统的告警数" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/rooms/:room_id/point_alarms/count" do 
    before(:each) do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |ssi|
        sub_system = create(:sub_system, name: "sub_system_#{ssi}")
        (0..2).each do |pi|
          pattern = create(:pattern, sub_system: sub_system, name: "pattern_#{pi}_#{ssi}")
          (0..3).each do |i|
            device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
            (0..i).each do |index|
              point = create(:point, device: device)
              create(:point_alarm, point: point, device: point.device, sub_system: point.device.pattern.sub_system, room: @room)
              @points << point
            end
          end
        end
      end
    end

    let(:room_id) { @room.id }
    let(:sub_system_id) { SubSystem.last.id }
    let(:raw_post) { params.to_json }

    parameter :room_id, "机房ID", required: true
    parameter :sub_system_id, "子系统ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "处理结果"

    example "获取子系统下设备的告警数" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/rooms/:room_id/point_alarms/count" do 
    before(:each) do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |ssi|
        sub_system = create(:sub_system, name: "sub_system_#{ssi}")
        (0..2).each do |pi|
          pattern = create(:pattern, sub_system: sub_system, name: "pattern_#{pi}_#{ssi}")
          (0..3).each do |i|
            device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
            (0..i).each do |index|
              point = create(:point, device: device)
              create(:point_alarm, point: point, device: point.device, sub_system: point.device.pattern.sub_system, room: @room)
              @points << point
            end
          end
        end
      end
    end

    let(:room_id) { @room.id }

    parameter :room_id, "机房ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :result, "处理结果"

    example "获取机房下子系统的告警数" do
      do_request
      expect(status).to eq(200)
    end
  end

  get "/point_alarms/:id" do 
    before(:each) do
      create(:user)
      @room = create(:room)
      @points = []
      (0..3).each do |ssi|
        sub_system = create(:sub_system, name: "sub_system_#{ssi}")
        (0..2).each do |pi|
          pattern = create(:pattern, sub_system: sub_system, name: "pattern_#{pi}_#{ssi}")
          (0..3).each do |i|
            device = create(:device, room: @room, name: "device#{i}", pattern: pattern)
            (0..i).each do |index|
              point = create(:point, device: device)
              create(:point_alarm, point: point, device: point.device, sub_system: point.device.pattern.sub_system, room: @room)
              @points << point
            end
          end
        end
      end
    end

    let(:id) { @points.last.id }
    let(:raw_post) { params.to_json }

    parameter :id, "告警ID", required: true

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "告警ID"
    response_field :device_name, "设备名"
    response_field :state, "告警状态"
    response_field :created_at, "创建时间"
    response_field :updated_at, "更新时间"
    response_field :is_checked, "是否确认"
    response_field :point_id, "点ID"
    response_field :comment, "说明"
    response_field :checked_user, "确认人"

    example "获取告警详情" do
      do_request
      expect(status).to eq(200)
    end
  end

  post "/point_alarms" do 
    before(:each) do
      room = create(:room)
      sub_system = create(:sub_system, name: "sub_system_1")
      pattern = create(:pattern, sub_system: sub_system, name: "pattern_1")
      device = create(:device, room: room, name: "device_1", pattern: pattern)
      point = create(:point, device: device)
    end

    parameter :point_index, "点ID", required: true
    parameter :time, "告警时间", required: true
    parameter :state, "告警状态", required: true
    parameter :alarm_value, "告警信息（如：Return Value:22）", required: false
    parameter :alarm_type, "告警类型（0：遥测点，1：遥信点）", required: true
    parameter :comment, "描述（点信息表里的Comment字段）", required: true

    let(:point_index) { "123456" }
    let(:time) { "2016-04-19 18:18:18" }
    let(:state) { 0 }
    let(:alarm_value) { "Return Value:22" }
    let(:alarm_type) { 0 }
    let(:comment) { "漏水" }

    let(:raw_post) { params.to_json }

    # :point_index, :time, :status, :alarm_value, :alarm_type, :point_type
    parameter :point_index, "点ID", required: true
    parameter :time, "告警时间", required: true
    parameter :state, "告警状态", required: true
    parameter :alarm_value, "告警信息（遥信点才有。如：Return Value:22）", required: false
    parameter :alarm_type, "告警类型（0：遥测点，1：遥信点）", required: true
    parameter :comment, "描述（点信息表里的Comment字段）", required: true

    response_field :error_code, "错误码"
    response_field :error_info, "错误信息"

    example "更新告警信息成功" do
      do_request
      expect(status).to eq(200)
    end
  end
end
