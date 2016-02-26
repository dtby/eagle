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
  before_action :authenticate_user!, only: [:show, :alert, :checked_alert, :video, :pic, :refersh_alert]
  acts_as_token_authentication_handler_for User, only: [:index], fallback_to_devise: false
  acts_as_token_authentication_handler_for Admin, only: [:index], fallback_to_devise: false
  respond_to :json

  def index
    if current_user.present?
      @rooms = UserRoom.where(user: current_user).map { |e| e.room }
    elsif current_admin.present?
      @rooms = Room.all
    end
  end

  def show
  end

  def alert
    @point_alarms = PointAlarm.unchecked
                        .get_alarm_point_by_room(@room.id)
                        .paginate(page: params[:page], per_page: 20)
                        .order_desc
                        .is_warning_alarm
                        .keyword(params[:start_time], params[:end_time])
    puts "@point_alarms is #{@point_alarms.inspect}"
  end

  def checked_alert
    @point_alarms = PointAlarm.checked.get_alarm_point_by_room(@room.id)
                                      .paginate(page: params[:page], per_page: 20)
                                      .order_desc
                                      .keyword(params[:start_time], params[:end_time])
  end

  def refersh_alert
    respond_to do |format|
      format.js { }
    end
  end

  def video
  end

  def pic
    @pics = PictureDownload.keyword(params[:start_time], params[:end_time])
  end

end
