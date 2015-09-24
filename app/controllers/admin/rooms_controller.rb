class Admin::RoomsController < Admin::BaseController
	before_action :set_room, only: [:edit, :show, :update]
	respond_to :html, :js

	def new
		@room = Room.new
		respond_with @room
	end

	def create
		@room = Room.new(room_params)
		if @admin.save
			respond_with @rooms
		else
			render :new
		end
	end

	def index
		@rooms = Room.all
	end

	def edit
		@menus = @room.menu_to_s
		respond_with @room,@menus
	end

	def update
    
  end

	def show

	end

	private 

  def set_room
    @room = Room.where(id: params[:id]).first
  end

end
