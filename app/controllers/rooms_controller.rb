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
