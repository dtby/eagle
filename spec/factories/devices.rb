# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  pattern_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#

FactoryGirl.define do
  factory :device do
    name "MyString"
pattern nil
  end

end
