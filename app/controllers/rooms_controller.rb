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
  before_action :authenticate_user!, only: [:show, :alert, :checked_alert, :video, :pic]
  acts_as_token_authentication_handler_for User, only: [:index]
  respond_to :json

  def index
    @rooms = Room.all
    @rooms = @rooms.select { |room| UserRoom.find_by(room: room, user: current_user).present? }
  end

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
