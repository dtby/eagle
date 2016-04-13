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
#  checked_user :string(255)
#
# Indexes
#
#  index_alarm_histories_on_point_id  (point_id)
#

require 'rails_helper'

RSpec.describe AlarmHistory, type: :model do
end
