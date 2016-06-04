class PueController < BaseController
  before_action :authenticate_user!
	
  def index
   @room = Room.find_by_id params[:room_id]
   @single_value_points, @chart_data = @room.pue
  end
	
end
