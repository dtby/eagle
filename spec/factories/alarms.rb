# == Schema Information
#
# Table name: alarms
#
#  id           :integer          not null, primary key
#  voltage      :string(255)
#  current      :string(255)
#  volt_warning :boolean
#  cur_warning  :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

FactoryGirl.define do
  factory :alarm do
    voltage "MyString"
current "MyString"
volt_state "MyString"
cur_state "MyString"
  end

end
