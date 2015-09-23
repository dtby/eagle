class Admin::UsersController < Admin::BaseController
	before_action :set_user, only: [:edit, :update, :destroy]
	respond_to :html, :js
	def index
		@users = User.all
	end

	def new
		@user = User.new
		respond_with @user
	end

	def create
		@user = User.new(user_params)
		if @user.save
			redirect_to admin_users_path
		else
			render :new
		end
	end

	def edit
		respond_with @user
	end

	def update
		if @user.update(user_params)
			redirect_to admin_users_path
		else
			render :edit
		end
	end

	def destroy
		@user.destroy
		redirect_to admin_users_path
	end

	private
	
	def user_params
		params.require(:user).permit(:email, :password, :name, :phone)
	end

	def set_user
		@user = User.find(params[:id])
	end
end
