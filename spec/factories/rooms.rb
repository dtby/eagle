# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  link       :string(255)
#

FactoryGirl.define do
  factory :room do
    name "MyString"
  end

end
