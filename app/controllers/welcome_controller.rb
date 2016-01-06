class WelcomeController < BaseController
  before_action :authenticate_user!
  
	def index
    @room = current_user.rooms.first
    redirect_to room_path(@room) if @room.present?
	end

  def auth
  end
end