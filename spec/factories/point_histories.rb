# == Schema Information
#
# Table name: point_histories
#
#  id          :integer          not null, primary key
#  point_name  :string(255)
#  point_value :float(24)
#  point_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_point_histories_on_point_id  (point_id)
#

FactoryGirl.define do
  factory :point_history do
    point_name "MyString"
point_value 1.5
point nil
  end

end
