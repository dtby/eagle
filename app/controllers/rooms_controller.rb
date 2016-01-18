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
    @rooms = UserRoom.where(user: current_user).map { |e| e.room }
  end

  def show
  end

  def alert
    @point_alarms = PointAlarm.unchecked
                        .get_alarm_point_by_room(@room.id)
                        .paginate(page: params[:page], per_page: 20)
                        .order_desc
                        .keyword(params[:start_time], params[:end_time])
  end

  def checked_alert
    @point_alarms = PointAlarm.checked.get_alarm_point_by_room(@room.id)
                                      .paginate(page: params[:page], per_page: 20)
                                      .order_desc
                                      .keyword(params[:start_time], params[:end_time])
  end

  def video
  end

  def pic
    @pics = PictureDownload.keyword(params[:start_time], params[:end_time])
  end

end
