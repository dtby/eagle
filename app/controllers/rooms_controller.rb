class RoomsController < BaseController
  def show
  end

  def alert
    @alerts = PointAlarm.get_alarm_point_by_room(@room.id)
  end
end
