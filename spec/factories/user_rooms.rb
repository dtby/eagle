# == Schema Information
#
# Table name: user_rooms
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_user_rooms_on_room_id  (room_id)
#  index_user_rooms_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_3ee87d0014  (user_id => users.id)
#  fk_rails_577ff954d1  (room_id => rooms.id)
#

FactoryGirl.define do
  factory :user_room do
    user nil
room nil
  end

end
