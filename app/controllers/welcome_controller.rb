class WelcomeController < BaseController
	def index
    @room = current_user.rooms.first
    redirect_to room_path(@room) if @room.present?
	end

  def auth
  end
end