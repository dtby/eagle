# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  room_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_systems_on_room_id  (room_id)
#

FactoryGirl.define do
  factory :system do
    sys_name "MyString"
sub_system ""
room nil
  end

end
