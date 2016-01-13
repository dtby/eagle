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

end
