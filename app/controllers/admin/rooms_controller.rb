class Admin::RoomsController < Admin::BaseController
	before_action :set_room, only: [:edit, :show, :update]
	respond_to :html, :js

	def new
		@room = Room.new
		respond_with @room
	end

	def create
		@room = Room.new(room_params)
		if @room.save
			UserRoom.room_belongs_to_users(@room, params[:user_rooms])
			flash[:notice] = "创建成功"
			respond_with @rooms
		else
			flash[:error] = "创建失败"
			render :new
		end
	end

	def index
		@rooms = Room.all
	end

	def edit
		@menus = @room.menu_to_s
		@users = User.all
		respond_with @room,@menus
	end

	def update
    if @room.update(room_params)
    	Menu.update_menus_by_room(@room, params[:list])
			flash[:notice] = "更新成功"
			return redirect_to admin_rooms_path
		else
			flash[:notice] = "更新失败"
			return redirect_to admin_rooms_path
		end
  end

	def show

	end

	private 

	def room_params
		params.require(:room).permit(:name, :link)
	end

  def set_room
    @room = Room.where(id: params[:id]).first
  end

end
