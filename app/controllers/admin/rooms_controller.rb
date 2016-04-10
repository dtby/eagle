class Admin::RoomsController < AdminBaseController
	before_action :set_room, only: [:edit, :show, :update, :destroy]
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
		@rooms = Room.includes(:area).all
	end

	def edit
		@menus = @room.menu_to_s
		respond_with @room,@menus
	end

	def update
    if @room.update(room_params)
    	Menu.update_menus_by_room(@room, params[:list])
    	UserRoom.update_room_users(@room, params[:user_rooms])
			flash[:notice] = "更新成功"
		else
			@menus = @room.menu_to_s
			flash[:notice] = "更新失败"
		end
  end

  def destroy
  	@room.destroy
  	redirect_to  admin_rooms_path
  end

	def show

	end

	private 

	def room_params
		params.require(:room).permit(:name, :link, :monitor_link, :area_id)
	end

  def set_room
    @room = Room.where(id: params[:id]).first
  end

end
