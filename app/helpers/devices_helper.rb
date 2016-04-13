# == Schema Information
#
# Table name: devices
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  pattern_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  pic_path    :string(255)
#  state       :boolean          default(FALSE)
#  sub_room_id :integer
#
# Indexes
#
#  index_devices_on_pattern_id  (pattern_id)
#  index_devices_on_room_id     (room_id)
#

module DevicesHelper
  def warning_status warning_data
    case warning_data.to_i
    when 0
      content_tag(:i, nil, class: "warning green")
    when 1
      content_tag(:i, nil, class: "warning red")
    end
  end

  # 计算ups环形图标x轴位置
  def pie_x index
  	index.even? ? '25%' : '75%'
  end

  # 计算ups环形图标y轴位置
  def pie_y index
  	if index <= 1
  		'16.6%'
  	elsif index <= 3 && index > 1
  		'50%'
  	elsif index <= 5 && index > 3
  		'83.3%'
		end
  end
  
end
