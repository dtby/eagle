class Admin::UsersController < Admin::BaseController
	before_action :set_user, only: [:edit, :update, :destroy]
	before_action :set_users, only: [:index, :create, :update, :destroy]
	before_action :set_rooms, except: [:destroy]
	respond_to :html, :js

	def index
	end

	def new
		@user = User.new
		respond_with @user
	end

	def create
		@user = User.new(user_params)
		if @user.save
			UserRoom.save_user_rooms(@user, params[:user_rooms])
			flash[:notice] = "创建成功"
			respond_with @users
		else
			flash[:error] = "创建失败"
			render :new
		end
	end

	def edit
		respond_with @user
	end

	def update
		if @user.update_user(user_params)
			UserRoom.update_user_rooms(@user, params[:user_rooms])
			flash[:notice] = "更新成功"
			respond_with @users
		else
			flash[:error] = "更新失败"
			render :edit
		end
	end

	def destroy
		@user.destroy
		respond_with @users
	end

	private
	
	def user_params
		params.require(:user).permit(:email, :password, :name, :phone, :password_confirmation)
	end

	def set_user
		@user = User.find(params[:id])
	end

	def set_users
		@users = User.all
	end

	def set_rooms
		@rooms = Room.all
	end
end
