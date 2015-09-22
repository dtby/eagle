# == Schema Information
#
# Table name: exclude_menus
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
#  index_exclude_menus_on_menuable_id_and_menuable_type  (menuable_id,menuable_type)
#  index_exclude_menus_on_room_id                        (room_id)
#

require 'rails_helper'

RSpec.describe ExcludeMenu, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
