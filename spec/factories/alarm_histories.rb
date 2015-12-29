# == Schema Information
#
# Table name: alarm_histories
#
#  id           :integer          not null, primary key
#  point_id     :integer
#  checked_time :datetime
#  check_state  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_alarm_histories_on_point_id  (point_id)
#
# Foreign Keys
#
#  fk_rails_e54dc154ed  (point_id => points.id)
#

FactoryGirl.define do
  factory :alarm_history do
    state 1
point nil
checked_time "2015-12-29 16:49:45"
check_state 1
  end

end
