class RoomsController < BaseController
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
    @pics = PictureDownload.pic_list
  end
end
