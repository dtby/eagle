class V2::RoomsController < BaseController
  acts_as_token_authentication_handler_for User, only: [:show, :pue]
  # before_action :set_room, only: [:show, :pue]
  respond_to :json

  def show

  end

  def pue
    @pues = Room.get_pue params[:id]
  end

  private

  def set_room
    @room = Room.where(id: params[:id]).first
  end
end
