require 'acceptance_helper'

resource "点列表" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  post "/devices/:id/points/get_value_by_names" do
    before do
      @room = create(:room)
      (0..3).each do |di|
        @device = create(:device, name: "device_#{di}", room: @room)
        (0..3).each do |pi|
          create(:point, device: @device, name: "point_#{pi}", point_index: "#{di}#{pi}")
          $redis.hset "eagle_point_value", "#{di}#{pi}", pi.to_s
        end
      end
    end

    parameter :names, "点名字", required: true, scope: :point

    let(:id) { @device.id }
    let(:names) { "point_1|point_2" }
    let(:raw_post) { params.to_json }

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :name, "用户ID"
    response_field :value, "邮箱"

    example "获取点列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
