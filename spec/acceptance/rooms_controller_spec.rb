require 'acceptance_helper'

resource "机房" do
  header "Accept", "application/json"
  header "Content-Type", "application/json"

  get "/rooms" do
    before do
      @rooms = []
      @rooms << create(:room, name: "room1")
      @rooms << create(:room, name: "room2")
      create(:room, name: "room3")
      user = create(:user)
      @rooms.each do |room|
        create(:user_room, room: room, user: user)
      end
    end

    user_attrs = FactoryGirl.attributes_for(:user)
    header "X-User-Token", user_attrs[:authentication_token]
    header "X-User-Phone", user_attrs[:phone]

    response_field :id, "机房ID"
    response_field :name, "机房名"

    example "获取机房列表成功" do
      do_request
      expect(status).to eq(200)
    end
  end

end
