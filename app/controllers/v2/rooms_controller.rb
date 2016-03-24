class V2::RoomsController < BaseController
  acts_as_token_authentication_handler_for User, only: [:show, :pue]
  before_action :set_room, only: [:show, :pue]
  respond_to :json

  def show

  end

  def pue
    @pue_cache = $redis.lrange "pue_#{@room.id}", 0, 5
  end

  private
  def room_params
		params.require(:room).permit(:id)
	end

  def set_room
    @room = Room.where(id: params[:id]).first
  end
end
