class Admin::AdminsController < Admin::BaseController
	before_action :set_admin, only: [:edit, :update, :destroy]
	def index
		@admins = Admin.all
	end

	def new
		@admin = Admin.new
	end

	def create
		@admin = Admin.new(admin_params)
		if @admin.save
			redirect_to admin_admins_path
		else
			render :new
		end
	end

	def edit
	end

	def update
		if @admin.update(admin_params)
			redirect_to admin_admins_path
		else
			render :edit
		end
	end

	def destroy
		@admin.destroy
		redirect_to admin_admins_path
	end

	 private
	 def admin_params
	 	params.require(:admin).permit(:email, :password)
	 end
	 def set_admin
	 	@admin = Admin.find(params[:id])
	 end
end