# == Schema Information
#
# Table name: rooms
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  link         :string(255)
#  monitor_link :string(255)
#

class RoomsController < BaseController
  before_action :authenticate_user!
  
  def show
  end

  def alert
    @alerts = PointAlarm.unchecked
                        .get_alarm_point_by_room(@room.id)
  end

  def checked_alert
    @alerts = PointAlarm.checked.get_alarm_point_by_room(@room.id)
  end

  def video
  end

  def pic
    @pics = PictureDownload.keyword(params[:start_time], params[:end_time])
  end
end
