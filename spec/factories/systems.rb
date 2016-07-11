# == Schema Information
#
# Table name: systems
#
#  id         :integer          not null, primary key
#  sys_name   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  path       :string(255)
#

FactoryGirl.define do
  factory :system do
    sys_name "MyString"
  end

end
