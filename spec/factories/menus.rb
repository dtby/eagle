# == Schema Information
#
# Table name: menus
#
#  id            :integer          not null, primary key
#  room_id       :integer
#  menuable_id   :integer
#  menuable_type :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_menus_on_menuable_id_and_menuable_type  (menuable_id,menuable_type)
#  index_menus_on_room_id                        (room_id)
#
# Foreign Keys
#
#  fk_rails_7165794c7e  (room_id => rooms.id)
#

FactoryGirl.define do
  factory :menu do
    
  end

end
