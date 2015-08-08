require 'rails_helper'

RSpec.describe AnalogAlarm, type: :model do
  it { should belong_to :analog_point }
end
